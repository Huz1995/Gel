import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gel/models/both_type_user_auth_model.dart';
import 'package:gel/models/login_auth_model.dart';
import 'package:http/http.dart' as http;

class AuthenticationProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _loggedInUser;
  late String? _idToken;
  bool _isLoggedIn = false;
  bool _isHairArtist = false;

  //register with email
  Future registerEmailPassword(UserRegisterFormData registerData) async {
    /*register the user with firebase auth and set the UID returned in register data*/
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: registerData.email!,
        password: registerData.password!,
      );
      registerData.setUID(result.user!.uid);
      _isLoggedIn = true;
      _isHairArtist = registerData.isHairArtist!;
      _loggedInUser = _auth.currentUser!;
      _idToken = await _auth.currentUser!.getIdToken();
      Timer(
        Duration(seconds: 1),
        () => {
          notifyListeners(),
        },
      );
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
      await _auth.signInWithEmailAndPassword(
          email: loginData.email!, password: loginData.password!);
      _loggedInUser = _auth.currentUser!;
      _isLoggedIn = true;
      _idToken = await _loggedInUser!.getIdToken();
    } catch (e) {
      print(e);
      return Future.error(e);
    }
    try {
      var response = await http.get(
        Uri.parse("http://localhost:3000/api/user/" + _loggedInUser!.uid),
      );
      _isHairArtist = (response.body == 'true');
      Timer(
        Duration(seconds: 1),
        () => {
          notifyListeners(),
        },
      );
    } catch (e) {
      print(e);
    }
  }

  void logUserOut() async {
    _isLoggedIn = false;
    _isHairArtist = false;
    _loggedInUser = null;
    _idToken = null;
    _auth.signOut();
    notifyListeners();
  }

  bool get isLoggedIn {
    return _isLoggedIn;
  }

  bool get isHairArtist {
    return _isHairArtist;
  }

  User get userCredentials {
    return _loggedInUser!;
  }

  String get idToken {
    return _idToken!;
  }
}
