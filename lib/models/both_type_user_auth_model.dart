/*class model is used to tak data input from register form and save as an obkect*/
class UserRegisterFormData {
  String? _uid;
  String? _email;
  String? _password;
  bool? _isHairArtist;
  String? _photoURL;

  void setUID(String? uid) {
    _uid = uid;
  }

  void setEmail(String? email) {
    _email = email;
  }

  void setPassword(String? password) {
    _password = password;
  }

  void setPhotoURL(String? photoURL) {
    _photoURL = photoURL;
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

  /*used to send http requests to the backend*/
  Map<String, String> toObject() {
    return {
      'uid': _uid!,
      'email': _email!,
      'isHairArtist': _isHairArtist!.toString(),
      'photoURL': _photoURL == null ? "null" : _photoURL!,
    };
  }
}
