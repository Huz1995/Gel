import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gel/models/location.dart';
import 'package:gel/models/place_search.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

/*connects to google places api to get place data using api key*/
class MapPlacesProvider with ChangeNotifier {
  List<PlaceSearch> _searchResults = [];
  Location currentPlace = Location(lat: 0, lng: 0);
  final String apiKey = "AIzaSyAuIU3HgoEKkWtRKzpY-q1ZsAvE-EOsEMw";

  /*This takes in a string client uses in search bar and sends to url*/
  Future<void> getAutoComplete(String search) async {
    var url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=(cities)&=pt_BR&key=$apiKey";
    /*the reponse has a list of places related to the string*/
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    /*for each place prediction object we create a place model with the name and id 
    we use the id to get details of the place's location*/
    var jsonResult = json['predictions'];
    final List<PlaceSearch> placeSearchList = jsonResult
        .map<PlaceSearch>((place) => PlaceSearch.fromJson(place))
        .toList();
    _searchResults = placeSearchList;
    notifyListeners();
  }

  /*function that takes the place id and return the location of the place
  that the map widget controller will use to go the location*/
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
