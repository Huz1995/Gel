class HairArtistUserProfile {
  String _uid;
  String _email;
  bool _isHairArtist;
  List<String> _photoUrls;

  HairArtistUserProfile(
    this._uid,
    this._email,
    this._isHairArtist,
    this._photoUrls,
  );

  String get uid {
    return _uid;
  }

  String get email {
    return _email;
  }

  bool get isHairArtist {
    return _isHairArtist;
  }

  List<String> get photoUrls {
    return _photoUrls;
  }

  void printProfile() {
    print(_uid);
    print(_email);
    print(_isHairArtist);
    print(_photoUrls);
  }

  void addPhotoUrl(String url) {
    this._photoUrls.insert(0, url);
  }
}
