import 'package:flutter/material.dart';

import 'chat_message_model.dart';

/*model used for the message widget*/
class MetaChatData {
  String? receiverUID;
  String? recieverName;
  String? receiverPhotoUrl;
  String? senderUID;
  String? senderName;
  String? roomID;
  String? latestMessageTxt;
  DateTime? latestMessageTime;

  MetaChatData({
    @required this.receiverUID,
    @required this.recieverName,
    @required this.receiverPhotoUrl,
    @required this.senderUID,
    @required this.senderName,
    @required this.roomID,
    @required this.latestMessageTxt,
    @required this.latestMessageTime,
  });

  void printCMD() {
    print("receiverUID: ${receiverUID},senderUID: ${senderUID}");
  }
}
