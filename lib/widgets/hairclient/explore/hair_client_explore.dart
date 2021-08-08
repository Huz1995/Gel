import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gel/models/location.dart';
import 'package:gel/models/place_search.dart';
import 'package:gel/providers/map_hair_artists_retrieval.dart';
import 'package:gel/providers/map_places_provider.dart';
import 'package:gel/widgets/hairclient/explore/dummy.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';

class HairClientExplore extends StatefulWidget {
  @override
  _HairClientExploreState createState() => _HairClientExploreState();
}

class _HairClientExploreState extends State<HairClientExplore> {
  late GoogleMapController _googleMapController;
  FloatingSearchBarController _floatingSearchBarController =
      FloatingSearchBarController();

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
  Widget build(BuildContext context) {
    final _mapLocationProvider = Provider.of<MapPlacesProvider>(context);
    final List<PlaceSearch> _placeSearchResults =
        _mapLocationProvider.searchResults;
    final MapHairArtistRetrievalProvider _hairArtistRetrievalProvider =
        Provider.of<MapHairArtistRetrievalProvider>(context);
    final _markers = _hairArtistRetrievalProvider.markers;

    return Scaffold(
        body: Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(37.785834, -122.406417),
            zoom: 10,
          ),
          markers: _markers,
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
                          _hairArtistRetrievalProvider.getMarkers(
                            place,
                            false,
                            () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => New(),
                              ),
                            ),
                          );
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
    ));
  }
}
