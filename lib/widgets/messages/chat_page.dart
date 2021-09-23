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

/*this widget displays the messages for the user*/
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
    /*get the latest chat room from the backend*/
    getAndSetChatRoom();
    /*disconnect socket from previous page*/
    widget.msgService!.disconnectSocket();
    /*go the bottom of the page ie last message*/
    animateListViewToBottom();
    /*start a new socket*/
    try {
      _socket = IO.io("https://gel-backend.herokuapp.com", <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });
      _socket.connect();
      _socket.on('connect', (_) => print("connect: ${_socket.id}"));
    } catch (error) {
      print(error.toString());
    }
    /*whenever the other user is sending a message on this channel then
    add the message to the list message list and set the state to re render the list
    the message will be stored in the chat room on the server*/
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

  /*this sets the chat room*/
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

  /*disconnects this chat socket and starts the other socket*/
  @override
  void dispose() {
    _socket.disconnect();
    _socket.on('disconnect', (data) => print("gone"));
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
              /*message bubbles from sender or reciever perspective*/
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
                      alignment: (messages[index].senderUID ==
                              widget.metaChatData!.senderUID
                          ? Alignment.topRight
                          : Alignment.topLeft),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (messages[index].senderUID ==
                                  widget.metaChatData!.senderUID
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
          /*this is the text field and submission button*/
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
                        // GestureDetector(
                        //   onTap: () {},
                        //   child: Container(
                        //     height: 30,
                        //     width: 30,
                        //     decoration: BoxDecoration(
                        //       color: Theme.of(context).primaryColor,
                        //       borderRadius: BorderRadius.circular(30),
                        //     ),
                        //     child: Icon(
                        //       Icons.add,
                        //       color: Colors.white,
                        //       size: 20,
                        //     ),
                        //   ),
                        // ),
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
                          /*sending a message*/
                          onPressed: () {
                            /*make sure it is not empty*/
                            if (_controller.value.text != "") {
                              /*create a new msg object from the text field value*/
                              Message messageObj = Message(
                                roomID: _chatRoom.roomID,
                                txtMsg: _controller.value.text,
                                receiverUID: widget.metaChatData!.receiverUID,
                                senderUID: widget.metaChatData!.senderUID,
                                time: DateTime.now(),
                              );
                              /*emit message on socket so the receiver can get it or stores in db*/
                              widget.msgService!.sendMessage(messageObj);
                              /*add this to the list so the user can see it on the ui and set state*/
                              setState(() {
                                messages.add(messageObj);
                              });
                              /*wipe the text field*/
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
