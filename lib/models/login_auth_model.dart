class LoginAuthData {
  String? _username;
  String? _password;

  void setUsername(String? username) {
    _username = username;
  }

  void setPassword(String? password) {
    _password = password;
  }

  String? get username {
    return _username;
  }

  String? get password {
    return _password;
  }
}
