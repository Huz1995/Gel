import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:gel/providers/messages_provider.dart';
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
  late MessagesProvider msgProvider;

  @override
  void initState() {
    msgProvider = Provider.of<MessagesProvider>(context, listen: false);
    msgProvider.socketServer();
    socket = msgProvider.socket;
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
    final _hairArtistProfileProvider =
        Provider.of<HairArtistProfileProvider>(context);
    final _fontSizeProvider =
        Provider.of<FontSizeProvider>(context, listen: false);
    final _messagesProvider = Provider.of<MessagesProvider>(context);

    return Scaffold(
      appBar: UIService.generalAppBar(context, "Messages", null),
      // body: ListView.builder(
      //   itemCount: _hairClientProfileProvider
      //       .hairClientProfile.favouriteHairArtists.length,
      //   itemBuilder: (context, index) {
      //     return MessageWidget(
      //       listIndex: index,
      //       hairArtistUserProfile: _hairClientProfileProvider
      //           .hairClientProfile.favouriteHairArtists[index],
      //     );
      //   },
      //   physics: ScrollPhysics(),
      // ),
      body: Center(
        child: Text("hhw"),
      ),
    );
  }
}
