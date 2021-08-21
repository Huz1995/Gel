import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:gel/providers/map_hair_artists_retrieval.dart';
import 'package:gel/providers/map_places_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:provider/provider.dart';
import 'hair_artist_msg_provider_init.dart';

class HairArtistProviders extends StatelessWidget {
  const HairArtistProviders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthenticationProvider>(context);
    /*to ensure when auto logout occurs then we remove this widget the tree*/
    if (!_authProvider.isLoggedIn) {
      Timer(
        Duration(seconds: 1),
        () => Navigator.popUntil(
          context,
          ModalRoute.withName('/landing'),
        ),
      );
    }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HairArtistProfileProvider(_authProvider),
        ),
        ChangeNotifierProvider(
          create: (context) => FontSizeProvider(context),
        ),
        ChangeNotifierProvider(
          create: (context) => MapPlacesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MapHairArtistRetrievalProvider(_authProvider),
        ),
      ],
      child: HairArtistMessageProviderInit(),
    );
  }
}
