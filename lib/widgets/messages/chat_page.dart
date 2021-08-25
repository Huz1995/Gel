import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gel/models/chat_message_model.dart';
import 'package:gel/models/chat_room_model.dart';
import 'package:gel/models/hair_artist_user_profile.dart';
import 'package:gel/models/meta_chat_model.dart';
import 'package:gel/providers/messages_service.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/providers/ui_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatPage extends StatefulWidget {
  late MetaChatData? metaChatData;
  late FontSizeProvider? fontSizeProvider;
  late MessagesSerivce? msgService;

  ChatPage({
    this.metaChatData,
    this.fontSizeProvider,
    this.msgService,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> messages = [];
  ScrollController scontroller = ScrollController();
  late IO.Socket _socket;
  late ChatRoom _chatRoom;

  @override
  void initState() {
    getAndSetChatRoom();
    widget.msgService!.disconnectSocket();
    animateListViewToBottom();

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
    _socket.on(widget.metaChatData!.senderUID!, (incommingMessage) {
      Message messageObj = Message(
        roomID: incommingMessage['room1'],
        txtMsg: incommingMessage['txtMsg'],
        receiverUID: incommingMessage['receiverUID'],
        senderUID: incommingMessage['senderUID'],
        time: DateTime.parse(incommingMessage['time']),
      );
      if (this.mounted) {
        setState(() {
          messages.add(messageObj);
        });
      }
      messageObj.printMessage();
    });
    super.initState();
  }

  void getAndSetChatRoom() async {
    var dummy =
        await widget.msgService!.getChatRoom(widget.metaChatData!.roomID!);
    setState(() {
      _chatRoom = dummy;
      messages = _chatRoom.messages!;
    });
  }

  void animateListViewToBottom() {
    Timer(
      Duration(milliseconds: 10),
      () => scontroller.animateTo(
        scontroller.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _socket.destroy();
    widget.msgService!.socketStart();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => animateListViewToBottom());

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
                controller: scontroller,
                itemCount: messages.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 10, bottom: 10),
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(
                        left: 16, right: 16, top: 10, bottom: 10),
                    child: Align(
                      alignment: (messages[index].receiverUID ==
                              widget.metaChatData!.receiverUID
                          ? Alignment.topRight
                          : Alignment.topLeft),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (messages[index].receiverUID ==
                                  widget.metaChatData!.receiverUID
                              ? Theme.of(context).accentColor.withOpacity(0.5)
                              : Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.5)),
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
                            if (_controller.value.text != "") {
                              Message messageObj = Message(
                                roomID: _chatRoom.roomID,
                                txtMsg: _controller.value.text,
                                receiverUID: widget.metaChatData!.receiverUID,
                                senderUID: widget.metaChatData!.senderUID,
                                time: DateTime.now(),
                              );
                              widget.msgService!.sendMessage(messageObj);
                              setState(() {
                                messages.add(messageObj);
                              });
                              messageObj.printMessage();
                              print(_controller.value.text);
                              _controller.clear();
                            }
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
