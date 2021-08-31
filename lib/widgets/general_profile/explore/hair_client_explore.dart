import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gel/models/location.dart';
import 'package:gel/models/place_search.dart';
import 'package:gel/providers/custom_dialogs.dart';
import 'package:gel/providers/hair_client_profile_provider.dart';
import 'package:gel/providers/map_hair_artists_retrieval.dart';
import 'package:gel/providers/map_places_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/providers/ui_service.dart';
import 'package:gel/widgets/general_profile/hair_artist_profile_display.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';

class HairClientExplore extends StatefulWidget {
  late bool? isForClientRoute;
  late HairClientProfileProvider? _hairClientProfileProvider;
  HairClientExplore({this.isForClientRoute});
  @override
  _HairClientExploreState createState() => _HairClientExploreState();
}

class _HairClientExploreState extends State<HairClientExplore>
    with AutomaticKeepAliveClientMixin {
  /*init controllers*/
  //late GoogleMapController _googleMapController;
  Completer<GoogleMapController> _googleMapController = Completer();

  @override
  bool get wantKeepAlive => true;

  FloatingSearchBarController _floatingSearchBarController =
      FloatingSearchBarController();
  late MapHairArtistRetrievalProvider _harp;

  /*function that goes to user location when map is loaded
  if permissions are ok*/
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
              Location location =
                  Location(lat: pos.latitude, lng: pos.longitude);
              _moveMapToLocation(location, null);
            },
          );
        }
      },
    );
  }

  /*function that takes in a location and moves to location using
  the controller*/
  Future<void> _moveMapToLocation(Location location, double? zoom) async {
    final GoogleMapController controller = await _googleMapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(location.lat!, location.lng!),
          zoom: zoom == null ? 10 : zoom,
        ),
      ),
    );
  }

  @override
  void initState() {
    /*when init state store the provider*/
    _harp = Provider.of<MapHairArtistRetrievalProvider>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    /*when leave map use provider to rid markers from memory*/
    _harp.resetMarkers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _fontSizeProvider =
        Provider.of<FontSizeProvider>(context, listen: false);

    /*if widget is coming from the hair client route then get the provider*/
    if (widget.isForClientRoute!) {
      setState(() {
        widget._hairClientProfileProvider =
            Provider.of<HairClientProfileProvider>(context);
      });
    }
    /*init required providers*/
    final _mapLocationProvider = Provider.of<MapPlacesProvider>(context);
    final List<PlaceSearch> _placeSearchResults =
        _mapLocationProvider.searchResults;
    final MapHairArtistRetrievalProvider _hairArtistRetrievalProvider =
        Provider.of<MapHairArtistRetrievalProvider>(context);
    final _markers = _hairArtistRetrievalProvider.markers;

    /*function that exeutes when the user taps on a place when searching
    for a place iin the search bar*/
    void Function()? _onTap({PlaceSearch? result, bool? isDisplayForArtist}) {
      return () async {
        /*get location details from the places the user chose*/
        var location =
            await _mapLocationProvider.getPlaceDetails(result!.placeId!);
        /*move the map to the location*/
        _moveMapToLocation(location, 12);
        /*closed the place list from the search bar*/
        _floatingSearchBarController.close();
        /*use the hair artist retrival provider to get hair artists
        within search radius critera and create markers from them*/
        _hairArtistRetrievalProvider.getMarkers(
          /*send location to back end*/
          location: location,
          /*send an on tap function so the hair retrieval provider can use
          to create on tap for markers*/
          /*the provider with iterate for each hair artist profile, so send this to
          to on tap funnction to create the hair artist user display widget*/
          onTap: (userProfile) => () {
            CustomDialogs.showMyDialogThreeButtons(
              context: context,
              title: Text("Get Directions"),
              body: [
                Text("Get directions to artist or navigate to their page")
              ],
              buttonOnechild: Text("Back"),
              buttonOneOnPressed: () => Navigator.of(context).pop(),
              buttonTwochild: Text("Direction"),
              buttonTwoOnPressed: () => print("Getting directions"),
              buttonThreechild: Text("Artist Profile"),
              buttonThreeOnPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HairArtistProfileDisplay(
                      hairArtistUserProfile: userProfile,
                      /*if the hair artist display is coming from the artist route of the map
                  we dont need hair artist provider*/
                      hairClientProfileProvider: isDisplayForArtist!
                          ? null
                          : widget._hairClientProfileProvider,
                      fontSizeProvider: _fontSizeProvider,
                      /*if the hair artist display is coming from the artist route of the map
                  we dont need too check if artist if favorite of the client*/
                      isFavOfClient: isDisplayForArtist
                          ? null
                          : HairClientProfileProvider.isAFavorite(
                              widget._hairClientProfileProvider!
                                  .hairClientProfile,
                              userProfile),
                      isForDisplay: true,
                      isDisplayForArtist: isDisplayForArtist,
                    ),
                  ),
                );
              },
            );
          },
        );
      };
    }

    return Scaffold(
        body: Stack(
      children: [
        /*google map is at bottom of the stack*/
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
            // _googleMapController = controller;
            _googleMapController.complete(controller);
            _onMapCreated();
          },
        ),
        /*put the search bar on top of the map*/
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
          /*when the user is changing search use the location provider
          to constantly get the search results from api, this uses
          notify listeners to update the PlaceSearch array so we can display
          new array on the map*/
          onQueryChanged: (query) {
            _mapLocationProvider.getAutoComplete(query);
          },
          // Specify a custom transition to be used for
          // animating between opened and closed stated.
          transition: CircularFloatingSearchBarTransition(),
          actions: [
            /*actions on the search bar*/
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
            /*use clip reect to display the places user searched in form list*/
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Material(
                color: Colors.white,
                elevation: 4.0,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  /*for the placeSearch results the map location provider
                  gets when user changes the search query, we map to a gesture detector
                  so when user clicks we can use the ontap funcyion above*/
                  children: _placeSearchResults.map(
                    (result) {
                      return GestureDetector(
                        child: Container(
                          height: 50,
                          child: Center(
                            child: Text(result.description!),
                          ),
                        ),
                        /*depending if the search is coming from client part or the
                        artist part of the app*/
                        onTap: widget.isForClientRoute!
                            ? _onTap(
                                result: result,
                                isDisplayForArtist: false,
                              )
                            : _onTap(
                                result: result,
                                isDisplayForArtist: true,
                              ),
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
