class HairArtistUserProfile {
  String _uid;
  String _email;
  String _idToken;
  bool _isHairArtist;

  HairArtistUserProfile(
    this._uid,
    this._email,
    this._idToken,
    this._isHairArtist,
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
}
