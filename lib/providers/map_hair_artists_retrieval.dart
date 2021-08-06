import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gel/models/hair_artist_user_profile.dart';
import 'package:gel/models/location.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class MapHairArtistRetrievalProvider with ChangeNotifier {
  List<HairArtistUserProfile> _searchedHairArtists = [];
  late String _loggedInUserIdToken;
  Timer? _liveLocationTimer;

  MapHairArtistRetrievalProvider(AuthenticationProvider auth) {
    _loggedInUserIdToken = auth.idToken;
  }

  Future<void> getHairArtistsAtLocation(Location location) async {
    cancelLiveLocationTimer();
    _liveLocationTimer = Timer.periodic(Duration(seconds: 3), (timer) async {
      _searchedHairArtists = [];
      var response = await http.post(
        Uri.parse("http://192.168.0.11:3000/api/searchHairArtists/"),
        body: {
          'lat': location.lat.toString(),
          'lng': location.lng.toString(),
        },
        headers: {
          HttpHeaders.authorizationHeader: _loggedInUserIdToken,
        },
      );
      /*convert the response from string to JSON*/
      var jsonResponse = convert.jsonDecode(response.body);
      (jsonResponse as List).forEach(
        (rawHairArtistUserData) {
          HairArtistAboutInfo about = new HairArtistAboutInfo(
            rawHairArtistUserData['about']['name'],
            rawHairArtistUserData['about']['contactNumber'],
            rawHairArtistUserData['about']['instaUrl'],
            rawHairArtistUserData['about']['description'],
            rawHairArtistUserData['about']['chatiness'],
            rawHairArtistUserData['about']['workingArrangement'],
            rawHairArtistUserData['about']['previousWorkExperience'],
            rawHairArtistUserData['about']['hairTypes'],
            rawHairArtistUserData['about']['hairServCost'],
          );
          HairArtistUserProfile userProfile = new HairArtistUserProfile(
            rawHairArtistUserData['uid'],
            rawHairArtistUserData['email'],
            rawHairArtistUserData['isHairArtist:'],
            (rawHairArtistUserData['photoUrls'] as List).cast<String>(),
            rawHairArtistUserData['profilePhotoUrl'],
            about,
            Location(
              lng: rawHairArtistUserData['location']['coordinates'][0],
              lat: rawHairArtistUserData['location']['coordinates'][1],
            ),
          );
          _searchedHairArtists.add(userProfile);
        },
      );
      _searchedHairArtists.isEmpty ? cancelLiveLocationTimer() : false;
      notifyListeners();
    });
  }

  List<HairArtistUserProfile> get searchedHairArtists {
    return _searchedHairArtists;
  }

  void cancelLiveLocationTimer() {
    if (_liveLocationTimer != null) {
      _liveLocationTimer!.cancel();
    }
  }

  @override
  void dispose() {
    if (_liveLocationTimer != null) {
      _liveLocationTimer!.cancel();
    }
    super.dispose();
  }
}
