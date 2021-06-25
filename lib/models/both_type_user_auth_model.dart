class UserRegisterFormData {
  String? _uid;
  String? _email;
  String? _password;
  bool? _isHairArtist;

  void setUID(String? uid) {
    _uid = uid;
  }

  void setEmail(String? email) {
    _email = email;
  }

  void setPassword(String? password) {
    _password = password;
  }

  void setIsHairArtist(bool? isHairArtist) {
    _isHairArtist = isHairArtist;
  }

  String? get uid {
    return _uid;
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

  Map<String, String> toObject() {
    return {
      'uid': _uid!,
      'email': _email!,
      'isHairArtist': _isHairArtist!.toString(),
    };
  }
}
