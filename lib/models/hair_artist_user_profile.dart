class HairArtistUserProfile {
  String _uid;
  String _email;
  String _idToken;
  bool _isHairArtist;
  List<String> _photoUrls;

  HairArtistUserProfile(
    this._uid,
    this._email,
    this._idToken,
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

  String get idToken {
    return _idToken;
  }

  List<String> get photoUrls {
    return _photoUrls;
  }

  void printProfile() {
    print(_uid);
    print(_email);
    print(_idToken);
    print(_isHairArtist);
    print(_photoUrls);
  }

  void addPhotoUrl(String url) {
    this._photoUrls.insert(0, url);
  }
}
