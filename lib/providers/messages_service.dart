import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gel/models/chat_message_model.dart';
import 'package:gel/models/chat_room_model.dart';
import 'package:gel/models/meta_chat_model.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

/*a service used to deal wit the message system between client and artist*/
class MessagesSerivce {
  late IO.Socket _socket;
  late AuthenticationProvider _auth;

  MessagesSerivce(AuthenticationProvider auth) {
    _auth = auth;
  }

  /*when the client wants to message new artist, the socket will emit the clients
  uid that wants to speak to artist, the channel isunique depending on the artist uid
  so the artist will recieve and then add to the client message list containing all the messages
  the artist is speakin too*/
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

  /*fuction that starts the socket connection*/
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

  /*function that emits the uids when the client wants to message to the artist
  which then stores in the database and sends the client uid to the artist
  using the fuction 2 above this*/
  void addNewMessageToUsers(String clientId, String artistId) {
    _socket.emit("_storeNewUIDs", {
      'clientUID': clientId,
      'artistUID': artistId,
    });
  }

  /*esnds a message on the send message channel with user sends message*/
  void sendMessage(Message message) {
    _socket.emit("_sendMessage", message.toObject());
  }

  /*this function gets the meta chat data for the user when requested*/
  Future<List<MetaChatData>> getChatMetaDataForUser(List<String> recieverUIDs,
      String senderName, String senderUID, String artistOrClient) async {
    /*depends on if the artist of client is the sender is requesting the meta data to display on message
       main page*/
    var response = await http.post(
      Uri.parse(
          "http://192.168.0.11:3000/api/messages/metaChatData${artistOrClient}Sender"),
      body: {
        'senderUID': senderUID,
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
      String roomID;
      if (artistOrClient == "Artist") {
        roomID = jsonResponse[i]['receiverUID'] + " " + senderUID;
      } else {
        roomID = senderUID + " " + jsonResponse[i]['receiverUID'];
      }
      var metaChatData = MetaChatData(
        receiverPhotoUrl: jsonResponse[i]['profilePhotoUrl'],
        receiverUID: jsonResponse[i]['receiverUID'],
        recieverName: jsonResponse[i]['receiverName'],
        senderName: senderName,
        senderUID: senderUID,
        roomID: roomID,
        latestMessageTxt: jsonResponse[i]['latestMessageTxt'],
        latestMessageTime: jsonResponse[i]['latestMessageTime'] == " "
            ? null
            : DateTime.parse(jsonResponse[i]['latestMessageTime']),
      );
      if (!metaChatDataArray.contains(metaChatData)) {
        metaChatDataArray.add(metaChatData);
      }
    }
    return metaChatDataArray;
  }

  Future<ChatRoom> getChatRoom(String roomId) async {
    var response = await http.get(
      Uri.parse("http://192.168.0.11:3000/api/messages/chatroom/" + roomId),
      headers: {
        HttpHeaders.authorizationHeader: _auth.idToken,
      },
    );
    var jsonReponse = convert.jsonDecode(response.body);
    var jsonMessages = jsonReponse['messages'] as List;
    List<Message> messages = [];
    for (int i = 0; i < jsonMessages.length; i++) {
      Message message = Message(
        id: jsonMessages[i]['_id'],
        roomID: jsonMessages[i]['roomID'],
        txtMsg: jsonMessages[i]['txtMsg'],
        receiverUID: jsonMessages[i]['receiverUID'],
        senderUID: jsonMessages[i]['senderUID'],
        time: DateTime.parse(jsonMessages[i]['time']),
      );
      messages.add(message);
    }
    var chatRoom = new ChatRoom(
      roomID: jsonReponse['roomID'],
      messages: messages,
    );
    return chatRoom;
  }

  IO.Socket get socket {
    return _socket;
  }

  void disconnectSocket() {
    _socket.disconnect();
  }
}
