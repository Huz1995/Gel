import 'package:flutter/cupertino.dart';
import 'package:gel/models/hair_artist_user_profile.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MessagesProviderArtist extends ChangeNotifier {
  late IO.Socket _socket;
  HairArtistProfileProvider _hairArtistProfileProvider;

  MessagesProviderArtist(this._hairArtistProfileProvider) {
    initMessageProvider();
    // print("here");
  }

  Future<void> initMessageProvider() async {
    await _hairArtistProfileProvider.getUserDataFromBackend();
    _socketStart();
    print(_hairArtistProfileProvider.hairArtistProfile.uid);
    _socket.on(
      _hairArtistProfileProvider.hairArtistProfile.uid,
      (data) => {
        _hairArtistProfileProvider
            .addClientUIDToHairArtistMessages(data['clientUID']),
        print(data['clientUID']),
      },
    );
  }

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

  IO.Socket get socket {
    return _socket;
  }

  @override
  void dispose() {
    _socket.disconnect();
    super.dispose();
  }
}
