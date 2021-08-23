import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gel/models/meta_chat_model.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:gel/providers/messages_provider_artist.dart';
import 'package:gel/providers/messages_provider_client.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/providers/ui_service.dart';
import 'package:gel/widgets/hairclient/favourites/favourite_widget.dart';
import 'package:gel/widgets/messages/message_widget.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MessagesMainPageArtitst extends StatefulWidget {
  @override
  _MessagesMainPageArtitstState createState() =>
      _MessagesMainPageArtitstState();
}

class _MessagesMainPageArtitstState extends State<MessagesMainPageArtitst> {
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _hairArtistProfileProvider =
        Provider.of<HairArtistProfileProvider>(context);
    final _fontSizeProvider =
        Provider.of<FontSizeProvider>(context, listen: false);
    final _messageProviderArtist = Provider.of<MessagesProviderArtist>(context);

    return Scaffold(
      appBar: UIService.generalAppBar(context, "Messages", null),
      body: FutureBuilder(
        future: _messageProviderArtist.getChatMetaDataForArtist(
            _hairArtistProfileProvider
                .hairArtistProfile.hairClientMessagingUids,
            _hairArtistProfileProvider.hairArtistProfile.about.name,
            _hairArtistProfileProvider.hairArtistProfile.uid),
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
