import 'package:flutter/cupertino.dart';
import 'package:gel/models/hair_artist_user_profile.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MessagesProvider extends ChangeNotifier {
  late IO.Socket _socket;

  List<HairArtistUserProfile> artistsHairClientMessenging = [];

  Future<void> getArtistsForHairClientMessenges(List<String> artistUids) async {
    print(artistUids);
  }

  Future<void> storeUsersUIDMessenger(
      String clientUID, String artistUID) async {}

  void socketServer() {
    try {
      _socket = IO.io("http://192.168.0.11:3000", <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });
      _socket.connect();
      _socket.on('connect', (_) => print("connect: ${_socket.id}"));
      print("herre");
    } catch (error) {
      print(error.toString());
    }
  }

  IO.Socket get socket {
    return socket;
  }
}
