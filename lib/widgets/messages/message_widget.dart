import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gel/models/hair_artist_user_profile.dart';
import 'package:gel/models/meta_chat_model.dart';
import 'package:gel/providers/messages_service.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/providers/ui_service.dart';
import 'package:gel/widgets/messages/chat_page.dart';
import 'package:provider/provider.dart';

class MessageWidget extends StatelessWidget {
  late int? listIndex;
  late MetaChatData? metaChatData;
  late MessagesSerivce? msgService;
  MessageWidget({this.listIndex, this.metaChatData, this.msgService});

  Widget build(BuildContext context) {
    final _fontSizeProvider = Provider.of<FontSizeProvider>(context);

    return GestureDetector(
      onTap: () {
        msgService!.disconnectSocket();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatPage(
              metaChatData: metaChatData,
              fontSizeProvider: _fontSizeProvider,
              msgService: msgService,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    UIService.getProfilePicIcon(
                        hasProfilePic: (metaChatData!.receiverPhotoUrl != null),
                        context: context,
                        url: metaChatData!.receiverPhotoUrl,
                        radius: 30),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              metaChatData!.recieverName!,
                              style: _fontSizeProvider.headline4,
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            // Text(
                            //   widget.messageText,
                            //   style: TextStyle(
                            //       fontSize: 13,
                            //       color: Colors.grey.shade600,
                            //       fontWeight: widget.isMessageRead
                            //           ? FontWeight.bold
                            //           : FontWeight.normal),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Text(
              //   widget.time,
              //   style: TextStyle(
              //       fontSize: 12,
              //       fontWeight: widget.isMessageRead
              //           ? FontWeight.bold
              //           : FontWeight.normal),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
