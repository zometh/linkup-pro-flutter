

import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../api/api_constants.dart';
class WebsocketConfig{
  final url = ApiConstants.baseUrl;
  IO.Socket? socket;
  void initSocket(){
    socket = IO.io(
      url,
      IO.OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .disableAutoConnect()  // disable auto-connection
          .build(),
    );
  }
  emit(String event, Map<String, dynamic> data){
    socket?.emit(event, data);
  }

}