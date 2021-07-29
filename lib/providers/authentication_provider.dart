import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:gel/models/both_type_user_auth_model.dart';
import 'package:gel/models/login_auth_model.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookSignIn = FacebookLogin();

  late String? _idToken;
  bool _isLoggedIn = false;
  bool _isHairArtist = false;
  late Timer _logoutTimer;

  //register with email
  Future<void> registerEmailPassword(UserRegisterFormData registerData) async {
    /*register the user with firebase auth and set the UID returned in register data*/
    UserCredential result = await _auth.createUserWithEmailAndPassword(
      email: registerData.email!,
      password: registerData.password!,
    );
    registerData.setUID(result.user!.uid);
    print("here");
    /*add the firebase uid to reg data model to send to backend*/

    /*send registration data to our api to store the user in mongoDb*/
    await http.post(
      Uri.parse("http://192.168.0.11:3000/api/authentication/registration"),
      body: registerData.toObject(),
    );
    /*set isLogged in and hairArtist booleans so main.dart can render correct screen*/
    await _setFrontEndLoginStateAfterRegistration(registerData);
  }

  Future<AuthCredential> _googleGetAuthCredential() async {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );
    return credential;
  }

  Future<AuthCredential> _facebookGetAuthCredential(
      FacebookLoginResult result) async {
    final FacebookAccessToken fbToken = result.accessToken;
    final AuthCredential credential =
        FacebookAuthProvider.credential(fbToken.token);

    return credential;
  }

  Future<void> _registerUser(String photoURL) async {
    print(photoURL);
    print(_auth.currentUser);
    UserRegisterFormData registerData = UserRegisterFormData();
    registerData.setEmail(_auth.currentUser!.email);
    registerData.setUID(_auth.currentUser!.uid);
    registerData.setIsHairArtist(_isHairArtist);
    registerData.setPhotoURL(photoURL);
    var response = await http.get(
      Uri.parse("http://192.168.0.11:3000/api/authentication/" +
          _auth.currentUser!.uid),
    );
    if (response.body == "User does not exist") {
      await http.post(
        Uri.parse("http://192.168.0.11:3000/api/authentication/registration"),
        body: registerData.toObject(),
      );
      await _setFrontEndLoginStateAfterRegistration(registerData);
    } else {
      _facebookSignIn.logOut();
      _googleSignIn.signOut();
      throw ("This account is already registered with Gel");
    }
  }

  /*function that turns login state to on after reg is sucessfull*/
  Future<void> _setFrontEndLoginStateAfterRegistration(
      UserRegisterFormData registerData) async {
    /*set isLogged in and hairArtist booleans so main.dart can render correct screen*/
    _isLoggedIn = true;
    _isHairArtist = registerData.isHairArtist!;
    /*store idToken expires in one hour*/
    _idToken = await _auth.currentUser!.getIdToken();
    /*timer is set so the animations of slide panel are in sync*/
    notifyListeners();
    _logoutTimer = Timer(
      Duration(seconds: 3600),
      () async {
        await logUserOut();
      },
    );
  }

  Future<void> googleRegistration() async {
    final AuthCredential credential = await _googleGetAuthCredential();
    try {
      await _auth.signInWithCredential(credential);
    } catch (e) {
      throw e.toString();
    }
    try {
      await _registerUser(_auth.currentUser!.photoURL!);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> facebookRegistration() async {
    final FacebookLoginResult result = await _facebookSignIn.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final AuthCredential credential =
            await _facebookGetAuthCredential(result);
        try {
          await _auth.signInWithCredential(credential);
        } catch (e) {
          throw e.toString();
        }
        try {
          await _registerUser(_auth.currentUser!.photoURL!);
        } catch (e) {
          throw e.toString();
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        throw (result.errorMessage);
    }
  }

  Future<void> loginEmailPassword(LoginFormData loginData) async {
    await _auth.signInWithEmailAndPassword(
        email: loginData.email!, password: loginData.password!);
    /*same as above*/
    _isLoggedIn = true;
    _idToken = await _auth.currentUser!.getIdToken();
    /*need to query the database to see if hair artist or client logs in
      to render the correct screen*/
    var response = await http.get(
      Uri.parse("http://192.168.0.11:3000/api/authentication/" +
          _auth.currentUser!.uid),
    );
    _isHairArtist = (response.body == 'true');
    /*notify the listeners listen to the changes in notifier atttributes*/
    notifyListeners();
    /*Firebase idToken expires in an hour so log usre out*/
    _logoutTimer = Timer(
      Duration(seconds: 3600),
      () async {
        await logUserOut();
      },
    );
  }

  Future<void> _loginUser() async {
    var response = await http.get(
      Uri.parse("http://192.168.0.11:3000/api/authentication/" +
          _auth.currentUser!.uid),
    );
    if (response.body != "User does not exist") {
      _isHairArtist = (response.body == 'true');
      _isLoggedIn = true;
      _idToken = await _auth.currentUser!.getIdToken();
      /*notify the listeners listen to the changes in notifier atttributes*/
      notifyListeners();
      /*Firebase idToken expires in an hour so log usre out*/
      _logoutTimer = Timer(
        Duration(seconds: 3600),
        () async {
          await logUserOut();
        },
      );
    } else {
      _facebookSignIn.logOut();
      _googleSignIn.signOut();
      _auth.currentUser!.delete();
      throw "This account is not registered with Gel";
    }
  }

  Future<void> loginWithGoogle() async {
    final AuthCredential credential = await _googleGetAuthCredential();
    try {
      await _auth.signInWithCredential(credential);
    } catch (e) {
      throw e.toString();
    }
    try {
      await _loginUser();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> loginWithFacebook() async {
    final FacebookLoginResult result = await _facebookSignIn.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final AuthCredential credential =
            await _facebookGetAuthCredential(result);
        try {
          await _auth.signInWithCredential(credential);
        } catch (e) {
          throw e.toString();
        }
        try {
          await _loginUser();
        } catch (e) {
          throw e.toString();
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        throw (result.errorMessage);
    }
  }

  Future<void> changePassword(String password) async {
    try {
      await _auth.currentUser!.updatePassword(password);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> logUserOut() async {
    _isLoggedIn = false;
    _isHairArtist = false;
    _idToken = null;
    await _auth.signOut();
    print(_auth.currentUser);
    _logoutTimer.cancel();
    await _googleSignIn.signOut();
    await _facebookSignIn.logOut();
    notifyListeners();
  }

  bool get isLoggedIn {
    return _isLoggedIn;
  }

  bool get isHairArtist {
    return _isHairArtist;
  }

  String get idToken {
    return _idToken!;
  }

  FirebaseAuth get firebaseAuth {
    return _auth;
  }

  void setIsHairArtist(bool isHairArtist) {
    _isHairArtist = isHairArtist;
  }
}
