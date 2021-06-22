class BothTypeUserAuthData {
  String? _username;
  String? _email;
  String? _password;
  bool? _isHairArtist;

  void setUsername(String? username) {
    _username = username;
  }

  void setEmail(String? email) {
    _email = email;
  }

  void setPassword(String? password) {
    _password = password;
  }

  void setIsHairArtist(bool? isHairArtist) {
    _isHairArtist = _isHairArtist;
  }

  String? get username {
    return _username;
  }

  String? get email {
    return _email;
  }

  String? get password {
    return _password;
  }

  bool? get isHairArtist {
    return _isHairArtist;
  }
}
