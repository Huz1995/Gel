class Location {
  final double? lat;
  final double? lng;

  Location({this.lat, this.lng});

  /*factory takes in a json object with lat and lng as attributs*/
  factory Location.fromJson(Map<dynamic, dynamic> json) {
    return Location(
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}
