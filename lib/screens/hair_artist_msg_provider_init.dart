import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:gel/providers/messages_provider_artist.dart';

import 'package:gel/screens/hair_artist_after_login.dart';
import 'package:provider/provider.dart';

class HairArtistMessageProviderInit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hairArtistProfileProvider =
        Provider.of<HairArtistProfileProvider>(context, listen: false);

    return ChangeNotifierProvider(
      create: (context) => MessagesProviderArtist(hairArtistProfileProvider),
      child: HairArtistHomePage(),
    );
  }
}
