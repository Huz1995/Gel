import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gel/models/meta_chat_model.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class MessagesSerivce {
  late IO.Socket _socket;
  late AuthenticationProvider _auth;

  MessagesSerivce(AuthenticationProvider auth) {
    _auth = auth;
  }

  Future<void> artistRecieveNewMsgInit(
      HairArtistProfileProvider hairArtistProfileProvider) async {
    _socket.on(
      hairArtistProfileProvider.hairArtistProfile.uid,
      (data) => {
        if (!hairArtistProfileProvider.hairArtistProfile.hairClientMessagingUids
            .contains(data['clientUID']))
          {
            hairArtistProfileProvider
                .addClientUIDToHairArtistMessages(data['clientUID']),
          },
        print(data['clientUID']),
      },
    );
  }

  void socketStart() {
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

  Future<List<MetaChatData>> getChatMetaDataForUser(List<String> recieverUIDs,
      String senderName, String senderUID, String artistOrClient) async {
    var response = await http.post(
      Uri.parse(
          "http://192.168.0.11:3000/api/messages/metaChatData${artistOrClient}Sender"),
      body: {
        'recieverUIDs': recieverUIDs.toString(),
      },
      headers: {
        HttpHeaders.authorizationHeader: _auth.idToken,
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
          senderName: senderName,
          senderUID: senderName);
      metaChatDataArray.add(metaChatData);
    }
    return metaChatDataArray;
  }

  IO.Socket get socket {
    return _socket;
  }

  void disconnectSocket() {
    _socket.disconnect();
  }
}
