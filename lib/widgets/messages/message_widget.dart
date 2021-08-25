import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gel/models/chat_room_model.dart';
import 'package:gel/models/hair_artist_user_profile.dart';
import 'package:gel/models/meta_chat_model.dart';
import 'package:gel/providers/messages_service.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/providers/ui_service.dart';
import 'package:gel/widgets/messages/chat_page.dart';
import 'package:provider/provider.dart';

class MessageWidget extends StatelessWidget {
  late MetaChatData? metaChatData;
  late MessagesSerivce? msgService;
  late void Function()? onTap;
  MessageWidget({this.metaChatData, this.msgService, this.onTap});

  Widget build(BuildContext context) {
    print("ere");
    final _fontSizeProvider = Provider.of<FontSizeProvider>(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        //padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Container(
          margin: EdgeInsets.all(10),
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).primaryColor.withOpacity(0.5),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 16,
                    ),
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
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                metaChatData!.recieverName!,
                                style: _fontSizeProvider.headline4,
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Container(
                              height: 40,
                              child: Text(
                                metaChatData!.latestMessageTxt!,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade900,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                metaChatData!.latestMessageTime == null
                    ? " "
                    : metaChatData!.latestMessageTime!.toString(),
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade900,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
