import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gel/models/meta_chat_model.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/hair_client_profile_provider.dart';
import 'package:gel/providers/messages_service.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/providers/ui_service.dart';
import 'package:gel/widgets/hairclient/favourites/favourite_widget.dart';
import 'package:gel/widgets/messages/message_widget.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'chat_page.dart';

class MessagesMainPageClient extends StatefulWidget {
  String? newArtistUIDForMessages;
  HairClientProfileProvider? hairClientProvider;
  MessagesMainPageClient({
    @required this.newArtistUIDForMessages,
    @required this.hairClientProvider,
  });

  @override
  _MessagesMainPageClientState createState() => _MessagesMainPageClientState();
}

class _MessagesMainPageClientState extends State<MessagesMainPageClient> {
  late MessagesSerivce _msgService;
  @override
  void initState() {
    _msgService = MessagesSerivce(
        Provider.of<AuthenticationProvider>(context, listen: false));
    _msgService.socketStart();
    if (this.mounted) {
      _msgService.socket.on(widget.hairClientProvider!.hairClientProfile.uid,
          (_) {
        widget.hairClientProvider!.getUserDataFromBackend();
      });
    }
    if (widget.newArtistUIDForMessages != null) {
      _msgService.addNewMessageToUsers(
          widget.hairClientProvider!.hairClientProfile.uid,
          widget.newArtistUIDForMessages!);
    }
    super.initState();
  }

  @override
  void dispose() {
    _msgService.disconnectSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _fontSizeProvider =
        Provider.of<FontSizeProvider>(context, listen: false);
    return Scaffold(
      appBar: UIService.generalAppBar(context, "Messages", null),
      body: FutureBuilder(
        future: _msgService.getChatMetaDataForUser(
            widget
                .hairClientProvider!.hairClientProfile.hairArtistMessagingUids,
            widget.hairClientProvider!.hairClientProfile.name,
            widget.hairClientProvider!.hairClientProfile.uid,
            "Client"),
        builder: (BuildContext context,
            AsyncSnapshot<List<MetaChatData>> metaChatDataArray) {
          if (metaChatDataArray.hasData) {
            print("\n");
            print(metaChatDataArray.data);
            print("\n");
            return ListView.builder(
              itemCount: widget.hairClientProvider!.hairClientProfile
                  .hairArtistMessagingUids.length,
              itemBuilder: (context, index) {
                return MessageWidget(
                  metaChatData: metaChatDataArray.data?[index],
                  msgService: _msgService,
                  onTap: () {
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          metaChatData: metaChatDataArray.data?[index],
                          fontSizeProvider: _fontSizeProvider,
                          msgService: _msgService,
                        ),
                      ),
                    )
                        .then((_) {
                      _msgService.socketStart();
                      setState(() {});
                    });
                  },
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
