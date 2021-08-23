import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gel/models/meta_chat_model.dart';
import 'package:gel/providers/hair_client_profile_provider.dart';
import 'package:gel/providers/messages_provider_client.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/providers/ui_service.dart';
import 'package:gel/widgets/hairclient/favourites/favourite_widget.dart';
import 'package:gel/widgets/messages/message_widget.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MessagesMainPageClient extends StatefulWidget {
  @override
  _MessagesMainPageClientState createState() => _MessagesMainPageClientState();
}

class _MessagesMainPageClientState extends State<MessagesMainPageClient> {
  late IO.Socket socket;

  @override
  void initState() {
    socket = Provider.of<MessagesProviderClient>(context, listen: false).socket;
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _hairClientProfileProvider =
        Provider.of<HairClientProfileProvider>(context);
    final _fontSizeProvider =
        Provider.of<FontSizeProvider>(context, listen: false);
    final _messagesProviderClient =
        Provider.of<MessagesProviderClient>(context);

    print(_hairClientProfileProvider.hairClientProfile.hairArtistMessagingUids);

    return Scaffold(
      appBar: UIService.generalAppBar(context, "Messages", null),
      body: FutureBuilder(
        future: _messagesProviderClient.getChatMetaDataForClient(
            _hairClientProfileProvider
                .hairClientProfile.hairArtistMessagingUids,
            _hairClientProfileProvider.hairClientProfile.name,
            _hairClientProfileProvider.hairClientProfile.uid),
        builder: (BuildContext context,
            AsyncSnapshot<List<MetaChatData>> metaChatDataArray) {
          print(metaChatDataArray.data);
          if (metaChatDataArray.hasData) {
            return ListView.builder(
              itemCount: _hairClientProfileProvider
                  .hairClientProfile.hairArtistMessagingUids.length,
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
