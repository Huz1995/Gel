import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gel/models/hair_artist_user_profile.dart';
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
  late StreamSubscription<Position> _positionStream;

  @override
  void initState() {
    super.initState();
    print("dffd");

    Geolocator.checkPermission().then(
      (value) async {
        if (value == LocationPermission.denied ||
            value == LocationPermission.deniedForever) {
          Geolocator.requestPermission().then(
            (value) async {
              if (value == LocationPermission.denied ||
                  value == LocationPermission.deniedForever) {
                CustomDialogs.showMyDialogOneButton(
                  context,
                  Text("Warning"),
                  [
                    Text(
                        "In order for people in you area to discover your services, you will need to add location services, in settings you can update your location services"),
                  ],
                  Text("Ok"),
                  () {
                    Navigator.of(context).pop();
                  },
                );
              } else {
                print(await Geolocator.getLastKnownPosition());
              }
            },
          );
        } else {
          _positionStream = Geolocator.getPositionStream(distanceFilter: 3)
              .listen((position) {
            print(position);
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
    final _hairArtistProvider = Provider.of<HairArtistProfileProvider>(context);
    final _hairArtistUserProfile = _hairArtistProvider.hairArtistProfile;
    final _phoneHeight = MediaQuery.of(context).size.height;
    final _phoneWidth = MediaQuery.of(context).size.width;
    return HairArtistProfileDisplay(
      phoneWidth: _phoneWidth,
      phoneHeight: _phoneHeight,
      hairArtistProvider: _hairArtistProvider,
      fontSizeProvider: _fontSizeProvider,
      hairArtistUserProfile: _hairArtistUserProfile,
      isForDisplay: false,
    );
  }
}
