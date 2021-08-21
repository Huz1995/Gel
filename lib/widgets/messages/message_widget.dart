import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gel/models/hair_artist_user_profile.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/providers/ui_service.dart';
import 'package:gel/widgets/messages/chat_page.dart';
import 'package:provider/provider.dart';

class MessageWidget extends StatelessWidget {
  late int? listIndex;
  late String? uid;

  MessageWidget({this.listIndex, this.uid});

  Widget build(BuildContext context) {
    final _fontSizeProvider = Provider.of<FontSizeProvider>(context);

    return GestureDetector(
      // onTap: () => Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => ChatPage(
      //       hairArtistUserProfile: hairArtistUserProfile,
      //       fontSizeProvider: _fontSizeProvider,
      //     ),
      //   ),
      // ),
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
                    // UIService.getProfilePicIcon(
                    //     hasProfilePic:
                    //         (hairArtistUserProfile!.profilePhotoUrl != null),
                    //     context: context,
                    //     url: hairArtistUserProfile!.profilePhotoUrl,
                    //     radius: 30),
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
                              uid!,
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
