class HairArtistUserProfile {
  String _uid;
  String _email;
  bool _isHairArtist;

  HairArtistUserProfile(
    this._uid,
    this._email,
    this._isHairArtist,
  );

  String? get uid {
    return _uid;
  }

  String? get email {
    return _email;
  }

  bool? get isHairArtist {
    return _isHairArtist;
  }

  Map<String, String> toObject() {
    return {
      'uid': _uid,
      'email': _email,
      'isHairArtist': _isHairArtist.toString(),
    };
  }
}
