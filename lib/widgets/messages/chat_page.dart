import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gel/models/chat_message_model.dart';
import 'package:gel/models/chat_room_model.dart';
import 'package:gel/models/hair_artist_user_profile.dart';
import 'package:gel/models/meta_chat_model.dart';
import 'package:gel/providers/messages_service.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/providers/ui_service.dart';

class ChatPage extends StatefulWidget {
  late MetaChatData? metaChatData;
  late FontSizeProvider? fontSizeProvider;
  late MessagesSerivce? msgService;

  ChatPage({this.metaChatData, this.fontSizeProvider, this.msgService});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatRoom _chatRoom;
  List<Message> messages = [
    Message(txtMsg: '323', roomID: "sdsd", receiverUID: "sender"),
    Message(txtMsg: "Hello, Will", receiverUID: "receiver"),
    Message(txtMsg: "How have you been?", receiverUID: "receiver"),
    Message(
        txtMsg: "Hey Kriss, I am doing fine dude. wbu?", receiverUID: "sender"),
    Message(txtMsg: "ehhhh, doing OK.", receiverUID: "receiver"),
    Message(txtMsg: "Is there any thing wrong?", receiverUID: "sender"),
  ];
  @override
  void initState() {
    widget.msgService!.socketStart();
    widget.msgService!.getChatRoom(widget.metaChatData!.roomID!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _controller = TextEditingController();
    return Scaffold(
      appBar: UIService.generalAppBar(
        context,
        "",
        SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                UIService.getProfilePicIcon(
                    hasProfilePic:
                        (widget.metaChatData!.receiverPhotoUrl != null),
                    context: context,
                    url: widget.metaChatData!.receiverPhotoUrl,
                    radius: 20),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.metaChatData!.recieverName!,
                        style: widget.fontSizeProvider!.headline4,
                      ),
                      SizedBox(
                        height: 6,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: ListView.builder(
                itemCount: messages.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 10, bottom: 10),
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(
                        left: 16, right: 16, top: 10, bottom: 10),
                    child: Align(
                      alignment: (messages[index].receiverUID == "receiver"
                          ? Alignment.topLeft
                          : Alignment.topRight),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (messages[index].receiverUID == "receiver"
                              ? Theme.of(context).primaryColor.withOpacity(0.5)
                              : Theme.of(context).accentColor.withOpacity(0.5)),
                        ),
                        padding: EdgeInsets.all(16),
                        child: Text(
                          messages[index].txtMsg!,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                    height: 60,
                    width: double.infinity,
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                                hintText: "Write message...",
                                hintStyle: TextStyle(color: Colors.black54),
                                border: InputBorder.none),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            print(_controller.value.text);
                            _controller.clear();
                          },
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 18,
                          ),
                          backgroundColor: Theme.of(context).accentColor,
                          elevation: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
