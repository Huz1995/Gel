import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gel/models/hair_artist_user_profile.dart';
import 'package:gel/models/location.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:gel/providers/hair_client_profile_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/providers/ui_service.dart';
import 'package:gel/widgets/general_profile/hair_artist_profile_display.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class MapHairArtistRetrievalProvider with ChangeNotifier {
  List<HairArtistUserProfile> _searchedHairArtists = [];
  Set<Marker> _markers = {};
  late String _loggedInUserIdToken;

  MapHairArtistRetrievalProvider(AuthenticationProvider auth) {
    _loggedInUserIdToken = auth.idToken;
  }

  Future<void> getHairArtistsAtLocation(Location location) async {
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
    List<dynamic> rawHairArtistUserDataList = (jsonResponse as List);
    for (int i = 0; i < rawHairArtistUserDataList.length; i++) {
      HairArtistUserProfile userProfile =
          await HairArtistProfileProvider.createUserProfile(
              rawHairArtistUserDataList[i], true, _loggedInUserIdToken);
      _searchedHairArtists.add(userProfile);
    }
    notifyListeners();
  }

  Future<void> getMarkers(Location location, BuildContext context,
      FontSizeProvider fsp, HairClientProfileProvider hcpp) async {
    await getHairArtistsAtLocation(location);
    _markers = {};
    notifyListeners();
    _searchedHairArtists.forEach(
      (userProfile) async {
        var location = userProfile.location;
        var marker = Marker(
          icon: userProfile.profilePhotoUrl != null
              ? await UIService.getMarkerIcon(
                  userProfile.profilePhotoUrl!,
                  Size(100, 100),
                )
              : BitmapDescriptor.defaultMarker,
          markerId: MarkerId(userProfile.uid),
          position: LatLng(
            location!.lat!,
            location.lng!,
          ),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => HairArtistProfileDisplay(
                  phoneWidth: MediaQuery.of(context).size.width,
                  phoneHeight: MediaQuery.of(context).size.height,
                  hairArtistUserProfile: userProfile,
                  hairClientProfileProvider: hcpp,
                  fontSizeProvider: fsp,
                  isFavOfClient: HairClientProfileProvider.isAFavorite(
                      hcpp.hairClientProfile, userProfile),
                  isForDisplay: true),
            ),
          ),
        );
        _markers.add(marker);
      },
    );
    notifyListeners();
  }

  List<HairArtistUserProfile> get searchedHairArtists {
    return _searchedHairArtists;
  }

  Set<Marker> get markers {
    return _markers;
  }

  void resetMarkers() {
    _markers = {};
  }
}
