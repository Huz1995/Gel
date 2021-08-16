/*creates a login object ued to send data to backend*/
class LoginFormData {
  String? _email;
  String? _password;

  void setEmail(String? email) {
    _email = email;
  }

  void setPassword(String? password) {
    _password = password;
  }

  String? get email {
    return _email;
  }

  String? get password {
    return _password;
  }
}
