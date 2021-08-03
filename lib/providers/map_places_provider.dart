import 'package:flutter/material.dart';
import 'package:gel/models/place_search.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class MapPlacesProvider with ChangeNotifier {
  List<PlaceSearch> _searchResults = [];

  Future<void> getAutoComplete(String search) async {
    final String key = "AIzaSyAuIU3HgoEKkWtRKzpY-q1ZsAvE-EOsEMw";
    var url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=(cities)&=pt_BR&key=AIzaSyAuIU3HgoEKkWtRKzpY-q1ZsAvE-EOsEMw";
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['predictions'];
    final List<PlaceSearch> placeSearchList = jsonResult
        .map<PlaceSearch>((place) => PlaceSearch.fromJson(place))
        .toList();

    _searchResults = placeSearchList;
    notifyListeners();
  }

  List<PlaceSearch> get searchResults {
    return _searchResults;
  }
}
