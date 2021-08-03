class Place {
  final double? lat;
  final double? lng;

  Place({this.lat, this.lng});

  factory Place.fromJson(Map<dynamic, dynamic> json) {
    return Place(
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}
