import 'dart:io';

import 'package:flutter/material.dart';
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
    socketServer();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  void socketServer() {
    try {
      socket = IO.io("http://192.168.0.11:3000", <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });
      socket.connect();
      socket.on('connect', (_) => print("connect: ${socket.id}"));
      print("herre");
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final _hairClientProfileProvider =
        Provider.of<HairClientProfileProvider>(context);
    final _fontSizeProvider =
        Provider.of<FontSizeProvider>(context, listen: false);

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
