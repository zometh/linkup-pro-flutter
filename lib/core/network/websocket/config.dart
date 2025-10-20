

import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/utils/services/my_logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../utils/services/localdb.dart';
import '../api/api_constants.dart';


class SocketService {
  final localDb = GetIt.I<LocalDBService>();
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  late IO.Socket _socket;
  bool _isConnected = false;

  SocketService._internal();

  Future<void> initSocket() async {
    String baseUrl = ApiConstants.baseUrl.replaceFirst('/api/v1', '');
    String ? token = await localDb.getToken();

    if (token == null || token.isEmpty) {
      MyLogger().log('⚠️ Aucun token trouvé. Socket non initialisé.');
      return;
    }

    if (_isConnected) {
      MyLogger().log('🔄 Socket déjà connecté.');
      return;
    }

    _socket = IO.io(
      baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(3000)
          .build(),
    );

    _socket.connect();


    _socket.onConnect((_) {
      _isConnected = true;
      MyLogger().log('✅ Socket connecté');
    });

    _socket.onDisconnect((_) {
      _isConnected = false;
      MyLogger().log('❌ Socket déconnecté');
    });

    _socket.onError((data) {
      MyLogger().log('⚠️ Erreur socket: $data');
    });
  }

  void emit(String event, dynamic data) {
    if (_isConnected) {
      _socket.emit(event, data);
    }
  }

  void dispose() {
    if (_isConnected) {
      _socket.disconnect();
      _isConnected = false;
      MyLogger().log('🛑 Socket fermé');
    }
  }
}
