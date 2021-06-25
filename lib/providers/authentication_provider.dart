import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gel/models/both_type_user_auth_model.dart';
import 'package:gel/models/login_auth_model.dart';
import 'package:http/http.dart' as http;

class AuthenticationProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoggedIn = false;
  late UserCredential _loggedInUser;
  late bool _isHairArtist;

  //register with email
  Future registerEmailPassword(UserRegisterFormData registerData) async {
    /*register the user with firebase auth and set the UID returned in register data*/
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: registerData.email!,
        password: registerData.password!,
      );
      registerData.setUID(result.user!.uid);
    } catch (e) {
      return Future.error(e);
    }
    /*send registration data to our api to store the user in mongoDb*/
    try {
      await http.post(
        Uri.parse("http://localhost:3000/api/user/registration"),
        body: registerData.toObject(),
      );
    } catch (e) {
      print(e);
    }
  }

  Future loginUserIn(LoginFormData loginData) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: loginData.email!, password: loginData.password!);
      _loggedInUser = result;
      _isLoggedIn = true;
    } catch (e) {
      return Future.error(e);
    }
    try {
      var response = await http.get(
        Uri.parse("http://localhost:3000/api/user/" + _loggedInUser.user!.uid),
      );
      _isHairArtist = (response.body == 'true');
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  bool get isLoggedIn {
    return _isLoggedIn;
  }

  bool get isHairArtist {
    return _isHairArtist;
  }
}
