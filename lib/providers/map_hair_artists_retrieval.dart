import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:gel/models/hair_artist_user_profile.dart';
import 'package:gel/models/location.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/widgets/hairclient/explore/dummy.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:ui' as ui;

class MapHairArtistRetrievalProvider with ChangeNotifier {
  List<HairArtistUserProfile> _searchedHairArtists = [];
  Set<Marker> _markers = {};
  late String _loggedInUserIdToken;
  late GlobalKey<NavigatorState> _navigatorKey;

  MapHairArtistRetrievalProvider(
      AuthenticationProvider auth, GlobalKey<NavigatorState> navigatorKey) {
    _loggedInUserIdToken = auth.idToken;
    _navigatorKey = navigatorKey;
  }

  Future<void> getHairArtistsAtLocation(
      Location location, bool shallNotifyListener) async {
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
    if (shallNotifyListener) {
      notifyListeners();
    }
  }

  Future<void> getMarkers(Location location, bool shallNotifyListener,
      void Function()? onTap) async {
    await getHairArtistsAtLocation(location, shallNotifyListener);
    _markers = {};
    notifyListeners();
    _searchedHairArtists.forEach(
      (userProfile) async {
        final File markerImageFile = await DefaultCacheManager()
            .getSingleFile(userProfile.profilePhotoUrl!);
        final Uint8List markerImageBytes = await markerImageFile.readAsBytes();
        ui.Codec codec = await ui.instantiateImageCodec(markerImageBytes,
            targetWidth: 100, targetHeight: 100);
        ui.FrameInfo fi = await codec.getNextFrame();
        final Uint8List markerImage =
            (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
                .buffer
                .asUint8List();
        var location = userProfile.location;
        var marker = Marker(
          icon: BitmapDescriptor.fromBytes(markerImage),
          markerId: MarkerId(userProfile.uid),
          position: LatLng(
            location!.lat!,
            location.lng!,
          ),
          onTap: onTap,
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
}
