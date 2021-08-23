import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/hair_client_profile_provider.dart';
import 'package:gel/providers/map_hair_artists_retrieval.dart';
import 'package:gel/providers/map_places_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/screens/hair_client_after_login.dart';
import 'package:provider/provider.dart';

class HairClientProviders extends StatelessWidget {
  const HairClientProviders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthenticationProvider>(context);
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
          create: (context) => HairClientProfileProvider(_authProvider),
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
      child: HairClientHomePage(),
    );
  }
}
