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
  late Timer _logoutTimer;

  //register with email
  Future registerEmailPassword(UserRegisterFormData registerData) async {
    /*register the user with firebase auth and set the UID returned in register data*/
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: registerData.email!,
        password: registerData.password!,
      );
      /*add the firebase uid to reg data model to send to backend*/
      registerData.setUID(result.user!.uid);
      /*set isLogged in and hairArtist booleans so main.dart can render correct screen*/
      _isLoggedIn = true;
      _isHairArtist = registerData.isHairArtist!;
      /*store firebase user details*/
      _loggedInUser = _auth.currentUser!;
      /*store idToken expires in one hour*/
      _idToken = await _auth.currentUser!.getIdToken();
      /*timer is set so the animations of slide panel are in sync*/
      notifyListeners();
      _logoutTimer = Timer(
        Duration(seconds: 3600),
        () {
          logUserOut();
        },
      );
    } catch (e) {
      /*if firebase error return it so registration form can display the error*/
      return Future.error(e);
    }
    /*send registration data to our api to store the user in mongoDb*/
    try {
      await http.post(
        Uri.parse("http://localhost:3000/api/authentication/registration"),
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
      /*same as above*/
      _loggedInUser = _auth.currentUser!;
      _isLoggedIn = true;
      _idToken = await _loggedInUser!.getIdToken();
      print(_idToken);
    } catch (e) {
      print(e);
      return Future.error(e);
    }
    try {
      /*need to query the database to see if hair artist or client logs in
      to render the correct screen*/
      var response = await http.get(
        Uri.parse(
            "http://localhost:3000/api/authentication/" + _loggedInUser!.uid),
      );
      _isHairArtist = (response.body == 'true');
      /*notify the listeners listen to the changes in notifier atttributes*/
      notifyListeners();
      /*Firebase idToken expires in an hour so log usre out*/
      _logoutTimer = Timer(
        Duration(seconds: 3600),
        () {
          logUserOut();
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
    _logoutTimer.cancel();
    notifyListeners();
  }

  bool get isLoggedIn {
    return _isLoggedIn;
  }

  bool get isHairArtist {
    return _isHairArtist;
  }

  User get loggedInUser {
    return _loggedInUser!;
  }

  String get idToken {
    return _idToken!;
  }
}
