import 'package:flutter/material.dart';

import 'chat_message_model.dart';

/*model used for the chatroom when user in chat page*/
class ChatRoom {
  String? roomID;
  List<Message>? messages;

  ChatRoom({
    this.roomID,
    this.messages,
  });

  void printChatRoom() {
    print('roomID: ${roomID}');
    messages!.forEach((element) {
      element.printMessage();
    });
  }
}
