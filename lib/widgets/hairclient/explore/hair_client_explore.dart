import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:gel/models/hair_artist_user_profile.dart';
import 'package:gel/models/location.dart';
import 'package:gel/models/place_search.dart';
import 'package:gel/providers/map_hair_artists_retrieval.dart';
import 'package:gel/providers/map_places_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

class HairClientExplore extends StatefulWidget {
  @override
  _HairClientExploreState createState() => _HairClientExploreState();
}

class _HairClientExploreState extends State<HairClientExplore> {
  late GoogleMapController _googleMapController;
  FloatingSearchBarController _floatingSearchBarController =
      FloatingSearchBarController();
  late MapHairArtistRetrievalProvider _hairArtistRetrievalProvider;

  void _onMapCreated() {
    Geolocator.checkPermission().then(
      (allowed) {
        if (allowed == LocationPermission.deniedForever) {
          print("using old coords");
        } else {
          print("functioncall");
          Geolocator.getCurrentPosition().then(
            (pos) {
              print(pos);
              _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(pos.latitude, pos.longitude),
                    zoom: 10,
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Future<void> _goToPlace(Location location) async {
    _googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(location.lat!, location.lng!),
          zoom: 10,
        ),
      ),
    );
  }

  @override
  void initState() {
    _hairArtistRetrievalProvider =
        Provider.of<MapHairArtistRetrievalProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _hairArtistRetrievalProvider.cancelLiveLocationTimer();
    print("gone");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _mapLocationProvider = Provider.of<MapPlacesProvider>(context);
    final List<PlaceSearch> _placeSearchResults =
        _mapLocationProvider.searchResults;
    final MapHairArtistRetrievalProvider _hairArtistRetrievalProvider =
        Provider.of<MapHairArtistRetrievalProvider>(context);
    final _hairArtistSearchResults =
        _hairArtistRetrievalProvider.searchedHairArtists;

    Future<Set<Marker>> _getMarkers(
        List<HairArtistUserProfile> hairArtistSearchResults) async {
      Set<Marker> markers = {};
      hairArtistSearchResults.forEach(
        (userProfile) async {
          final File markerImageFile = await DefaultCacheManager()
              .getSingleFile(userProfile.profilePhotoUrl!);
          final Uint8List markerImageBytes =
              await markerImageFile.readAsBytes();
          ui.Codec codec = await ui.instantiateImageCodec(markerImageBytes,
              targetWidth: 50, targetHeight: 50);
          ui.FrameInfo fi = await codec.getNextFrame();
          final Uint8List markerImage =
              (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
                  .buffer
                  .asUint8List();
          var location = userProfile.location;
          var marker = Marker(
            //icon: BitmapDescriptor.fromBytes(markerImage),
            markerId: MarkerId(userProfile.uid),
            position: LatLng(
              location!.lat!,
              location.lng!,
            ),
          );
          //print(marker);
          markers.add(marker);
        },
      );
      return markers;
    }

    return Scaffold(
      body: FutureBuilder(
        future: _getMarkers(_hairArtistSearchResults),
        builder: (BuildContext context, AsyncSnapshot<Set<Marker>> snapshot) {
          print(snapshot.data);

          return new Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(37.785834, -122.406417),
                  zoom: 10,
                ),
                //markers: snapshot,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                onMapCreated: (GoogleMapController controller) {
                  _googleMapController = controller;
                  _onMapCreated();
                },
              ),
              FloatingSearchBar(
                textInputAction: TextInputAction.done,
                controller: _floatingSearchBarController,
                backgroundColor: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                hint: '  Search by city or town...',
                scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
                transitionDuration: const Duration(milliseconds: 800),
                transitionCurve: Curves.easeInOut,
                physics: const BouncingScrollPhysics(),
                axisAlignment: 0.0,
                openAxisAlignment: 0.0,
                width: 600,
                debounceDelay: const Duration(milliseconds: 500),
                onQueryChanged: (query) {
                  _mapLocationProvider.getAutoComplete(query);
                },
                // Specify a custom transition to be used for
                // animating between opened and closed stated.
                transition: CircularFloatingSearchBarTransition(),
                actions: [
                  FloatingSearchBarAction(
                    showIfOpened: false,
                    child: CircularButton(
                      icon: const Icon(Icons.list),
                      onPressed: () {},
                    ),
                  ),
                  FloatingSearchBarAction.searchToClear(
                    showIfClosed: false,
                  ),
                ],
                builder: (context, transition) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Material(
                      color: Colors.white,
                      elevation: 4.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: _placeSearchResults.map(
                          (result) {
                            return GestureDetector(
                              child: Container(
                                height: 50,
                                child: Center(
                                  child: Text(result.description!),
                                ),
                              ),
                              onTap: () async {
                                var place = await _mapLocationProvider
                                    .getPlaceDetails(result.placeId!);
                                _goToPlace(place);
                                _floatingSearchBarController.close();
                                _hairArtistRetrievalProvider
                                    .getHairArtistsAtLocation(place);
                              },
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
