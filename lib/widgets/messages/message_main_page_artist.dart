import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gel/models/meta_chat_model.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:gel/providers/messages_service.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/providers/ui_service.dart';
import 'package:gel/widgets/hairclient/favourites/favourite_widget.dart';
import 'package:gel/widgets/messages/chat_page.dart';
import 'package:gel/widgets/messages/message_widget.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

/*widget that deals with the messenging from the artist side*/
class MessagesMainPageArtitst extends StatefulWidget {
  HairArtistProfileProvider? hairArtistProvider;
  MessagesMainPageArtitst({
    @required this.hairArtistProvider,
  });

  @override
  _MessagesMainPageArtitstState createState() =>
      _MessagesMainPageArtitstState();
}

class _MessagesMainPageArtitstState extends State<MessagesMainPageArtitst> {
  late MessagesSerivce _msgService;

  @override
  void initState() {
    /*create a messenging service*/
    _msgService = MessagesSerivce(
        Provider.of<AuthenticationProvider>(context, listen: false));
    widget.hairArtistProvider!.getUserDataFromBackend();
    _msgService.socketStart();
    /*this channel allows this widget to know whenever the client is sending a message to 
     the reciever ie this artist, when it does it will just get data from the back end to reset
     and display the new meta chat data for this widget, ie the latest text and time*/
    if (this.mounted) {
      _msgService.socket.on(widget.hairArtistProvider!.hairArtistProfile.uid,
          (_) {
        widget.hairArtistProvider!.getUserDataFromBackend();
      });
    }
    /*socket that allows the artist to know weahter a new client wants to messge them*/
    _msgService.artistRecieveNewMsgInit(widget.hairArtistProvider!);
    super.initState();
  }

  @override
  void dispose() {
    _msgService.disconnectSocket();
    super.dispose();
  }

/*same as client widget bur form artist perspective*/
  @override
  Widget build(BuildContext context) {
    final _fontSizeProvider =
        Provider.of<FontSizeProvider>(context, listen: false);
    return Scaffold(
      appBar: UIService.generalAppBar(context, "Messages", null),
      body: FutureBuilder(
        future: _msgService.getChatMetaDataForUser(
            widget
                .hairArtistProvider!.hairArtistProfile.hairClientMessagingUids,
            widget.hairArtistProvider!.hairArtistProfile.about.name,
            widget.hairArtistProvider!.hairArtistProfile.uid,
            "Artist"),
        builder: (BuildContext context,
            AsyncSnapshot<List<MetaChatData>> metaChatDataArray) {
          print(metaChatDataArray.data);
          if (metaChatDataArray.hasData) {
            return ListView(
              children: (metaChatDataArray.data as List)
                  .map(
                    (metaChatData) => MessageWidget(
                      metaChatData: metaChatData,
                      msgService: _msgService,
                      onTap: () {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              metaChatData: metaChatData,
                              fontSizeProvider: _fontSizeProvider,
                              msgService: _msgService,
                            ),
                          ),
                        )
                            .then(
                          (_) {
                            _msgService.socketStart();
                            setState(() {});
                          },
                        );
                      },
                    ),
                  )
                  .toList(),
            );
          }
          return Text("");
        },
      ),
    );
  }
}
