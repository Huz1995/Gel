import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gel/models/meta_chat_model.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class MessagesProviderArtist extends ChangeNotifier {
  late IO.Socket _socket;
  HairArtistProfileProvider _hairArtistProfileProvider;
  late String _loggedInUserIdToken;

  MessagesProviderArtist(
      this._hairArtistProfileProvider, AuthenticationProvider auth) {
    initMessageProvider();
    _loggedInUserIdToken = auth.idToken;
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

  Future<List<MetaChatData>> getChatMetaDataForArtist(
      List<String> clientUIDs, String artistName, String artistUid) async {
    var response = await http.post(
      Uri.parse(
          "http://192.168.0.11:3000/api/messages/metaChatDataArtistSender"),
      body: {
        'hairClientUIDs': clientUIDs.toString(),
      },
      headers: {
        HttpHeaders.authorizationHeader: _loggedInUserIdToken,
      },
    );
    var jsonResponse = (convert.jsonDecode(response.body) as List);
    List<MetaChatData> metaChatDataArray = [];
    print(jsonResponse);
    for (int i = 0; i < jsonResponse.length; i++) {
      var metaChatData = MetaChatData(
          receiverPhotoUrl: jsonResponse[i]['profilePhotoUrl'],
          receiverUID: jsonResponse[i]['receiverUID'],
          recieverName: jsonResponse[i]['receiverName'],
          senderName: artistName,
          senderUID: artistUid);
      metaChatDataArray.add(metaChatData);
    }
    return metaChatDataArray;
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
