import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gel/models/place.dart';
import 'package:gel/models/place_search.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class MapPlacesProvider with ChangeNotifier {
  List<PlaceSearch> _searchResults = [];
  Place currentPlace = Place(lat: 0, lng: 0);
  StreamController<Place> _placeStreamController = StreamController<Place>();
  final String apiKey = "AIzaSyAuIU3HgoEKkWtRKzpY-q1ZsAvE-EOsEMw";

  Future<void> getAutoComplete(String search) async {
    var url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=(cities)&=pt_BR&key=$apiKey";
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['predictions'];
    final List<PlaceSearch> placeSearchList = jsonResult
        .map<PlaceSearch>((place) => PlaceSearch.fromJson(place))
        .toList();

    _searchResults = placeSearchList;
    notifyListeners();
  }

  Future<void> getPlaceDetails(String id) async {
    var url =
        "https://maps.googleapis.com/maps/api/place/details/json?key=$apiKey&place_id=$id";
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['result']['geometry']['location'];
    final Place place = Place.fromJson(jsonResult);
    _placeStreamController.add(place);
  }

  List<PlaceSearch> get searchResults {
    return _searchResults;
  }

  StreamController<Place> get placeStreamController {
    return _placeStreamController;
  }
}
