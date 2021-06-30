import 'package:flutter/material.dart';
import 'package:gel/models/hair_artist_user_profile.dart';
import 'package:gel/providers/authentication_provider.dart';

//proivder that sends font sized depending on the screen size
class HairArtistProfileProvider extends ChangeNotifier {
  late HairArtistUserProfile _userProfile;
  HairArtistProfileProvider(AuthenticationProvider auth) {
    _userProfile = new HairArtistUserProfile(
      auth.loggedInUser.uid,
      auth.loggedInUser.email!,
      auth.idToken,
      auth.isHairArtist,
    );
  }
  HairArtistUserProfile get hairArtistProfile {
    return _userProfile;
  }
}
