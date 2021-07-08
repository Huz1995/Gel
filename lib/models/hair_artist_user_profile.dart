class HairArtistUserProfile {
  String _uid;
  String _email;
  bool _isHairArtist;
  List<String> _photoUrls;
  String? _profilePhotoUrl;

  HairArtistUserProfile(
    this._uid,
    this._email,
    this._isHairArtist,
    this._photoUrls,
    this._profilePhotoUrl,
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

  String? get profilePhotoUrl {
    return _profilePhotoUrl;
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

  void addProfilePictureUrl(String url) {
    this._profilePhotoUrl = url;
  }
}
