import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gel/providers/custom_dialogs.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/widgets/general_profile/hair_artist_profile_display.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class HairArtistProfileMainPage extends StatefulWidget {
  @override
  _HairArtistProfileMainPageState createState() =>
      _HairArtistProfileMainPageState();
}

class _HairArtistProfileMainPageState extends State<HairArtistProfileMainPage> {
  /*stream that updates postion of the artist*/
  late StreamSubscription<Position> _positionStream;

  @override
  void initState() {
    super.initState();

    Geolocator.checkPermission().then(
      (value) async {
        if (value == LocationPermission.denied ||
            value == LocationPermission.deniedForever) {
          Geolocator.requestPermission().then(
            (value) async {
              if (value == LocationPermission.denied ||
                  value == LocationPermission.deniedForever) {
                CustomDialogs.showMyDialogOneButton(
                  context: context,
                  title: Text("Warning"),
                  body: [
                    Text(
                        "In order for people in you area to discover your services, you will need to add location services, in settings you can update your location services"),
                  ],
                  buttonChild: Text("Ok"),
                  buttonOnPressed: () {
                    Navigator.of(context).pop();
                  },
                );
              } else {
                print(await Geolocator.getLastKnownPosition());
              }
            },
          );
        } else {
          /*if permissions allowed will update the position if the phone moves 3 meteres*/
          _positionStream = Geolocator.getPositionStream(distanceFilter: 3)
              .listen((position) {
            /*user provider to update location and send data to api*/
            Provider.of<HairArtistProfileProvider>(context, listen: false)
                .updateHairArtistLocation(
              position.latitude,
              position.longitude,
            );
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _positionStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _fontSizeProvider =
        Provider.of<FontSizeProvider>(context, listen: false);
    final _hairArtistProfileProvider =
        Provider.of<HairArtistProfileProvider>(context);
    final _hairArtistUserProfile = _hairArtistProfileProvider.hairArtistProfile;

    return HairArtistProfileDisplay(
      hairArtistProfileProvider: _hairArtistProfileProvider,
      fontSizeProvider: _fontSizeProvider,
      hairArtistUserProfile: _hairArtistUserProfile,
      isForDisplay: false,
      isDisplayForArtist: false,
    );
  }
}
