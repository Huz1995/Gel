import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:gel/models/hair_artist_user_profile.dart';
import 'package:gel/models/location.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/widgets/general_profile/hair_artist_profile_display.dart';
import 'package:gel/widgets/hairclient/explore/dummy.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:ui' as ui;

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
    notifyListeners();
  }

  Future<ui.Image> _getImageFromUrl(String url) async {
    Completer<ImageInfo> completer = Completer();
    var img = new NetworkImage(url);
    img
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info);
    }));
    ImageInfo imageInfo = await completer.future;
    return imageInfo.image;
  }

  Future<BitmapDescriptor> _getMarkerIcon(String url, Size size) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Radius radius = Radius.circular(size.width / 2);

    final Paint tagPaint = Paint()..color = Colors.blue;
    final double tagWidth = 40.0;

    final Paint shadowPaint = Paint()..color = Colors.blue.withAlpha(100);
    final double shadowWidth = 10.0;

    final Paint borderPaint = Paint()..color = Colors.white;
    final double borderWidth = 5.0;

    final double imageOffset = shadowWidth + borderWidth;

    // Add shadow circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, size.width, size.height),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        shadowPaint);

    // Add border circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(shadowWidth, shadowWidth,
              size.width - (shadowWidth * 2), size.height - (shadowWidth * 2)),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        borderPaint);

    // Oval for the image
    Rect oval = Rect.fromLTWH(imageOffset, imageOffset,
        size.width - (imageOffset * 2), size.height - (imageOffset * 2));

    // Add path for oval image
    canvas.clipPath(Path()..addOval(oval));

    // Add image
    ui.Image image = await _getImageFromUrl(
        url); // Alternatively use your own method to get the image
    paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitWidth);

    // Convert canvas to image
    final ui.Image markerAsImage = await pictureRecorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());

    // Convert image to bytes
    final ByteData? byteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }

  Future<void> getMarkers(
      Location location, BuildContext context, FontSizeProvider fsp) async {
    await getHairArtistsAtLocation(location);
    _markers = {};
    notifyListeners();
    _searchedHairArtists.forEach(
      (userProfile) async {
        var location = userProfile.location;
        var marker = Marker(
          icon: await _getMarkerIcon(
            userProfile.profilePhotoUrl!,
            Size(100, 100),
          ),
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
                  fontSizeProvider: fsp,
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
}
