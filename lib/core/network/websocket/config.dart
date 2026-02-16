import 'package:get_it/get_it.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

import '../../services/localdb/localdb.dart';
import '../../utils/my_logger.dart';
import '../api/api_constants.dart';

class SocketService {
  final localDb = GetIt.I<LocalDBService>();
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  socket_io.Socket? _socket;
  bool _isConnected = false;
  final List<Map<String, dynamic>> _pendingEmits = [];
  final Map<String, List<Function(dynamic)>> _pendingListeners = {};

  SocketService._internal();

  bool get isConnected => _isConnected;

  Future<void> initSocket() async {
    String baseUrl = ApiConstants.baseUrl.replaceFirst('/api/v1', '');
    String? token = await localDb.getToken();
    String? userId = await localDb.getUserId();

    if (token == null || token.isEmpty) {
      MyLogger().log('Aucun token trouvé. Socket non initialisé.');
      return;
    }

    if (_isConnected) {
      MyLogger().log('Socket déjà connecté.');
      return;
    }

    _socket = socket_io.io(
      baseUrl,
      socket_io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(3000)
          .setReconnectionDelayMax(10000)
          .build(),
    );

    _attachDefaultHandlers(userId);

    _socket!.connect();
  }

  void _attachDefaultHandlers(String? userId) {
    if (_socket == null) return;

    _socket!.onConnect((_) {
      _isConnected = true;
      MyLogger().log('Socket connecté');
      if (userId != null) {
        MyLogger().log('Émission événement register avec userId: $userId');
        _socket!.emit('register', {'userId': userId});
      } else {
        MyLogger().log('userId est null, impossible d\'émettre register');
      }

      _attachPendingListeners();

      _flushPendingEmits();
    });

    _socket!.onDisconnect((_) {
      _isConnected = false;
      MyLogger().log('Socket déconnecté');
    });

    _socket!.onError((data) {
      MyLogger().log('Erreur socket: $data');
    });

    _socket!.on('connect_error', (data) {
      MyLogger().log('connect_error: $data');
    });
    _socket!.on('connect_timeout', (data) {
      MyLogger().log('connect_timeout: $data');
    });
    _socket!.on('reconnect_attempt', (attempt) {
      MyLogger().log('reconnect_attempt: $attempt');
    });
    _socket!.on('reconnect', (attempt) {
      MyLogger().log('reconnected after attempt: $attempt');
    });
    _socket!.on('reconnect_error', (err) {
      MyLogger().log('reconnect_error: $err');
    });
    _socket!.on('reconnect_failed', (data) {
      MyLogger().log('reconnect_failed: $data');
    });

    _socket!.on('unauthorized', (data) async {
      MyLogger().log('Socket unauthorized: $data');
    });

    _socket!.on('registered', (data) {
      MyLogger().log('Registered confirmation received: $data');
    });
  }

  void _flushPendingEmits() {
    if (_socket == null) return;
    while (_pendingEmits.isNotEmpty && _isConnected) {
      final item = _pendingEmits.removeAt(0);
      try {
        _socket!.emit(item['event'] as String, item['data']);
      } catch (e) {
        MyLogger().log('Failed to flush emit: $e');
      }
    }
  }

  void _attachPendingListeners() {
    if (_socket == null) return;
    MyLogger().log(
      'Attaching ${_pendingListeners.length} pending listeners...',
    );
    _pendingListeners.forEach((event, callbacks) {
      for (var callback in callbacks) {
        MyLogger().log('Attaching pending listener for: $event');
        _socket!.on(event, callback);
      }
    });
    _pendingListeners.clear();
  }

  void emit(String event, dynamic data, {bool queueIfDisconnected = true}) {
    if (_socket != null && _isConnected) {
      _socket!.emit(event, data);
      return;
    }
    if (queueIfDisconnected) {
      _pendingEmits.add({'event': event, 'data': data});
    } else {
      MyLogger().log('Emit skipped (disconnected): $event');
    }
  }

  void joinRoom(
    String event,
    Map<String, dynamic> data, {
    bool queueIfDisconnected = true,
  }) {
    emit(event, data, queueIfDisconnected: queueIfDisconnected);
  }

  void on(String event, Function(dynamic) callback) {
    if (_socket != null) {
      MyLogger().log('Attaching listener for event: $event (socket exists)');
      _socket!.on(event, callback);
    } else {
      MyLogger().log('Socket is null, storing listener for event: $event');
      // Stocker le listener pour l'attacher plus tard
      if (!_pendingListeners.containsKey(event)) {
        _pendingListeners[event] = [];
      }
      _pendingListeners[event]!.add(callback);
    }
  }

  void off(String event, [Function? callback]) {
    if (_socket == null) return;
    try {
      if (callback == null) {
        _socket!.off(event);
      } else {
        _socket!.off(event, callback as dynamic);
      }
    } catch (e) {
      MyLogger().log('Error removing listener: $e');
    }
  }

  void dispose() {
    if (_socket != null) {
      try {
        _socket!.off('connect');
        _socket!.off('disconnect');
        _socket!.off('error');
        _socket!.off('connect_error');
        _socket!.off('connect_timeout');
        _socket!.off('reconnect_attempt');
        _socket!.off('reconnect');
        _socket!.off('reconnect_error');
        _socket!.off('reconnect_failed');
        _socket!.off('unauthorized');
      } catch (e) {
        MyLogger().log('Error removing listener: $e');
      }
      try {
        _socket!.disconnect();
      } catch (e) {
        MyLogger().log('Erreur lors de la déconnexion: $e');
      }
      _socket = null;
      _isConnected = false;
      _pendingEmits.clear();
      MyLogger().log('Socket fermé');
    }
  }
}
