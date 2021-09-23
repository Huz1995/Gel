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

/*provider that retreives the hair artists within 5km radius from location search*/
class MapHairArtistRetrievalProvider with ChangeNotifier {
  List<HairArtistUserProfile> _searchedHairArtists = [];
  Set<Marker> _markers = {};
  late String _loggedInUserIdToken;

  /*need auth provider to use idToken to protect routes*/
  MapHairArtistRetrievalProvider(AuthenticationProvider auth) {
    _loggedInUserIdToken = auth.idToken;
  }

  /*function that takes location object produced in map wiget when search
  and stores the hair artists at this location*/
  Future<void> getHairArtistsAtLocation(Location location) async {
    _searchedHairArtists = [];
    var response = await http.post(
      Uri.parse("https://gel-backend.herokuapp.com/api/searchHairArtists/"),
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
      /*create a hairartist user profile out of the raw json data*/
      HairArtistUserProfile userProfile =
          await HairArtistProfileProvider.createUserProfile(
              rawHairArtistUserDataList[i], true, _loggedInUserIdToken);
      /*add to the list and let widgets kknow using change notiifiers*/
      _searchedHairArtists.add(userProfile);
    }
    notifyListeners();
  }

  /*this function uses the ui service to use the profile url of each hair artist
  at location to create markers with the photo url*/
  Future<void> getMarkers({
    Location? location,
    void Function()? onTap(HairArtistUserProfile userProfile)?,
  }) async {
    /*use the functions above to create hair artist profile at location*/
    await getHairArtistsAtLocation(location!);
    _markers = {};
    notifyListeners();
    /*for each hair artist we create a marker*/
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
          /*this function is passed from the widget but will push the user to the artist profile page*/
          onTap: onTap!(userProfile),
        ); /*add marker to set and notify listener to update ui*/
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
