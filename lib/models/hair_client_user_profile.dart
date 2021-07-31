class HairClientUserProfile {
  String _uid;
  String _email;
  bool _isHairArtist;
  String? _profilePhotoUrl;
  String _name;

  HairClientUserProfile(
    this._uid,
    this._email,
    this._isHairArtist,
    this._profilePhotoUrl,
    this._name,
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

  String? get profilePhotoUrl {
    return _profilePhotoUrl;
  }

  String get name {
    return _name;
  }

  void setName(String name) {
    this._name = name;
  }

  void deleteProfilePhoto() {
    this._profilePhotoUrl = null;
  }

  void addProfilePictureUrl(String url) {
    this._profilePhotoUrl = url;
  }
}
