import 'dart:ffi';

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

/*displays meta chat data on message widget*/
class MessageWidget extends StatelessWidget {
  late MetaChatData? metaChatData;
  late MessagesSerivce? msgService;
  late void Function()? onTap;
  MessageWidget({this.metaChatData, this.msgService, this.onTap});

  Widget build(BuildContext context) {
    final _fontSizeProvider = Provider.of<FontSizeProvider>(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        //padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Container(
          margin: EdgeInsets.fromLTRB(1, 10, 1, 10),
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
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
                    /*get receiver profile pic*/
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
                            /*display reciever name*/
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Row(
                                children: [
                                  Text(
                                    metaChatData!.recieverName!,
                                    style: _fontSizeProvider.headline4,
                                  ),
                                  Spacer(),
                                  Text(
                                    metaChatData!.latestMessageTime == null
                                        ? " "
                                        : metaChatData!.latestMessageTime
                                            .toString()
                                            .split(" ")[0],
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade900,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            /*display latest mesage*/
                            Container(
                              margin: EdgeInsets.only(left: 5),
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
              /*display the latest message time*/
            ],
          ),
        ),
      ),
    );
  }
}
