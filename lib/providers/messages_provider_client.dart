import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MessagesProviderClient extends ChangeNotifier {
  late IO.Socket _socket;

  MessagesProviderClient() {
    _socketStart();
  }

  // Future<void> storeUsersUIDMessenger(
  //     String clientUID, String artistUID) async {}

  void _socketStart() {
    try {
      _socket = IO.io("http://192.168.0.11:3000", <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });
      _socket.connect();
      _socket.on('connect', (_) => print("connect: ${_socket.id}"));
    } catch (error) {
      print(error.toString());
    }
  }

  void addNewMessageToUsers(String clientId, String artistId) {
    print("new user");
    _socket.emit("_storeNewUIDs", {
      'clientUID': clientId,
      'artistUID': artistId,
    });
  }

  IO.Socket get socket {
    return _socket;
  }

  @override
  void dispose() {
    _socket.disconnect();
    // TODO: implement dispose
    super.dispose();
  }
}
