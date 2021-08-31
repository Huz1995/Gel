import 'package:gel/models/directions_model.dart';
import 'package:gel/models/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class DirectionsService {
  static const String _authority = "https://maps.googleapis.com";
  static const String _unencodedPath = "/maps/api/directions/json";
  static const String _apiKey = "AIzaSyAuIU3HgoEKkWtRKzpY-q1ZsAvE-EOsEMw";

  Future<Directions> getDirections(Location origin, Location direction) async {
    final _queryParamters = {
      'origin': '${origin.lat},${origin.lng}',
      'destination': '${origin.lat},${origin.lng}',
      'key': _apiKey,
    };
    final uri = Uri.https(_authority, _unencodedPath, _queryParamters);
    final response = await http.get(uri);
    final jsonResponse = convert.jsonDecode(response.body);
    return Directions.fromMap(jsonResponse.data);
  }
}
