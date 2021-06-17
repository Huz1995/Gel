import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(51.4545, 2.5879),
    zoom: 10,
  );

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController _ctr) {
    Geolocator.checkPermission().then((allowed) {
      if (allowed == LocationPermission.deniedForever) {
        print("using old coords");
      } else {
        print("functioncall");
        Geolocator.getCurrentPosition().then((pos) {
          print(pos);
          _ctr.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(pos.latitude, pos.longitude),
                zoom: 10,
              ),
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: MapPage._kGooglePlex,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              _onMapCreated(controller);
            },
          ),
          Positioned(
            left: MediaQuery.of(context).size.width / 13,
            top: MediaQuery.of(context).size.height / 13,
            child: FloatingActionButton(
                elevation: 10,
                backgroundColor: Theme.of(context).cardColor.withOpacity(0.8),
                onPressed: () => Navigator.pop(context),
                child: Container(
                  margin: EdgeInsets.only(left: 6),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: MediaQuery.of(context).size.width * 0.045,
                  ),
                )),
          )
        ],
      ),
    );
  }
}
