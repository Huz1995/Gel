import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:gel/models/meta_chat_model.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class MessagesProviderClient extends ChangeNotifier {
  late IO.Socket _socket;
  late String _loggedInUserIdToken;
  List<MetaChatData> metaChatData = [];

  MessagesProviderClient(AuthenticationProvider auth) {
    _socketStart();
    _loggedInUserIdToken = auth.idToken;
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

  Future<List<MetaChatData>> getChatMetaDataForClient(
      List<String> hairArtistUIDS, String clientName, String clientUid) async {
    print(hairArtistUIDS);
    var response = await http.post(
      Uri.parse(
          "http://192.168.0.11:3000/api/messages/metaChatDataClientSender"),
      body: {
        'hairArtistUIDs': hairArtistUIDS.toString(),
      },
      headers: {
        HttpHeaders.authorizationHeader: _loggedInUserIdToken,
      },
    );
    var jsonResponse = (convert.jsonDecode(response.body) as List);
    List<MetaChatData> metaChatDataArray = [];
    for (int i = 0; i < jsonResponse.length; i++) {
      var metaChatData = MetaChatData(
          receiverPhotoUrl: jsonResponse[i]['profilePhotoUrl'],
          receiverUID: jsonResponse[i]['receiverUID'],
          recieverName: jsonResponse[i]['receiverName'],
          senderName: clientName,
          senderUID: clientUid);
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
    // TODO: implement dispose
    super.dispose();
  }
}
