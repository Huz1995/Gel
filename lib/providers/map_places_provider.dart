import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gel/models/location.dart';
import 'package:gel/models/place_search.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class MapPlacesProvider with ChangeNotifier {
  List<PlaceSearch> _searchResults = [];
  Location currentPlace = Location(lat: 0, lng: 0);
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

  Future<Location> getPlaceDetails(String id) async {
    var url =
        "https://maps.googleapis.com/maps/api/place/details/json?key=$apiKey&place_id=$id";
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['result']['geometry']['location'];
    final Location location = Location.fromJson(jsonResult);
    return location;
  }

  List<PlaceSearch> get searchResults {
    return _searchResults;
  }
}
