import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gel/models/meta_chat_model.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:gel/providers/messages_service.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/providers/ui_service.dart';
import 'package:gel/widgets/hairclient/favourites/favourite_widget.dart';
import 'package:gel/widgets/messages/message_widget.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MessagesMainPageArtitst extends StatefulWidget {
  String? newArtistUIDForMessages;
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
    _msgService = MessagesSerivce(
        Provider.of<AuthenticationProvider>(context, listen: false));
    widget.hairArtistProvider!.getUserDataFromBackend();
    _msgService.socketStart();
    _msgService.artistRecieveNewMsgInit(widget.hairArtistProvider!);
    super.initState();
  }

  @override
  void dispose() {
    _msgService.disconnectSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _hairArtistProfileProvider =
        Provider.of<HairArtistProfileProvider>(context);
    final _fontSizeProvider =
        Provider.of<FontSizeProvider>(context, listen: false);

    return Scaffold(
      appBar: UIService.generalAppBar(context, "Messages", null),
      body:
          // ListView.builder(
          //   itemCount: _hairArtistProfileProvider
          //       .hairArtistProfile.hairClientMessagingUids.length,
          //   itemBuilder: (context, index) {
          //     return Text(_hairArtistProfileProvider
          //         .hairArtistProfile.hairClientMessagingUids[index]);
          //   },
          // ),
          FutureBuilder(
        future: _msgService.getChatMetaDataForUser(
            _hairArtistProfileProvider
                .hairArtistProfile.hairClientMessagingUids,
            _hairArtistProfileProvider.hairArtistProfile.about.name,
            _hairArtistProfileProvider.hairArtistProfile.uid,
            "Artist"),
        builder: (BuildContext context,
            AsyncSnapshot<List<MetaChatData>> metaChatDataArray) {
          print(metaChatDataArray.data);
          if (metaChatDataArray.hasData) {
            return ListView.builder(
              itemCount: _hairArtistProfileProvider
                  .hairArtistProfile.hairClientMessagingUids.length,
              itemBuilder: (context, index) {
                return MessageWidget(
                  listIndex: index,
                  metaChatData: metaChatDataArray.data?[index],
                  msgService: _msgService,
                );
              },
              physics: ScrollPhysics(),
            );
          }
          return Text("");
        },
      ),
    );
  }
}
