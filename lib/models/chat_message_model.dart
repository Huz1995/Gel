import 'package:flutter/material.dart';

class Message {
  String? id;
  String? roomID;
  String? txtMsg;
  String? receiverUID;
  String? senderUID;
  DateTime? time;

  Message({
    this.id,
    this.roomID,
    this.txtMsg,
    this.receiverUID,
    this.senderUID,
    this.time,
  });

  void printMessage() {
    print(
        "id: ${id},roomID: ${roomID},txtMsg: ${txtMsg},recieverUID: ${receiverUID},senderUID: ${senderUID},time: ${time}");
  }
}
