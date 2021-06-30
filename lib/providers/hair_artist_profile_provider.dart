import 'package:flutter/material.dart';
import 'package:gel/models/hair_artist_user_profile.dart';
import 'package:gel/providers/authentication_provider.dart';

//proivder that sends font sized depending on the screen size
class HairArtistProfileProvider extends ChangeNotifier {
  HairArtistUserProfile? _hairArtistUser;

  HairArtistProfileProvider(AuthenticationProvider auth) {
    _hairArtistUser = HairArtistUserProfile(
      auth.loggedInUser.uid,
      auth.loggedInUser.email!,
      auth.idToken,
      auth.isHairArtist,
    );
  }
}
