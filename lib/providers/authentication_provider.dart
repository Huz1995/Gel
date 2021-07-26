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
  final FacebookLogin facebookSignIn = FacebookLogin();

  late User? _loggedInUser;
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

    /*add the firebase uid to reg data model to send to backend*/
    /*set isLogged in and hairArtist booleans so main.dart can render correct screen*/
    setFrontEndLoginStateAfterRegistration(registerData);
    /*send registration data to our api to store the user in mongoDb*/

    await http.post(
      Uri.parse("http://localhost:3000/api/authentication/registration"),
      body: registerData.toObject(),
    );
  }

  Future<void> googleRegistration() async {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );

    /*check if user is already registered with gel*/
    List<String> previousMethods =
        await _auth.fetchSignInMethodsForEmail(googleSignInAccount.email);
    if (previousMethods.isNotEmpty) {
      _googleSignIn.signOut();
      throw ("This Google account is already registered with Gel");
    }

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);

    final User? user = authResult.user;
    UserRegisterFormData registerData = UserRegisterFormData();
    registerData.setEmail(user!.email);
    registerData.setUID(user.uid);
    registerData.setIsHairArtist(_isHairArtist);
    /*set isLogged in and hairArtist booleans so main.dart can render correct screen*/
    setFrontEndLoginStateAfterRegistration(registerData);
    await http.post(
      Uri.parse("http://localhost:3000/api/authentication/registration"),
      body: registerData.toObject(),
    );
  }

  Future<void> facebookRegistration() async {
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
    print(result);
  }

/*function that turns login state to on after reg is sucessfull*/
  void setFrontEndLoginStateAfterRegistration(
      UserRegisterFormData registerData) async {
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
  }

  Future<void> loginEmailPassword(LoginFormData loginData) async {
    await _auth.signInWithEmailAndPassword(
        email: loginData.email!, password: loginData.password!);
    /*same as above*/
    _loggedInUser = _auth.currentUser!;
    _isLoggedIn = true;
    _idToken = await _loggedInUser!.getIdToken();
    print(_idToken);

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
  }

  Future loginWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );
    /*check if user is already registered with gel*/
    List<String> signInProviders =
        await _auth.fetchSignInMethodsForEmail(googleSignInAccount.email);
    print(signInProviders);
    if (signInProviders.isEmpty) {
      _googleSignIn.signOut();
      throw ("This Google account is not registered with Gel");
    }
    await _auth.signInWithCredential(credential);
    _loggedInUser = _auth.currentUser!;
    _isLoggedIn = true;
    _idToken = await _loggedInUser!.getIdToken();
    print(_idToken);
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
  }

  void logUserOut() async {
    _isLoggedIn = false;
    _isHairArtist = false;
    _loggedInUser = null;
    _idToken = null;
    _auth.signOut();
    _logoutTimer.cancel();
    _googleSignIn.signOut();
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

  void setIsHairArtist(bool isHairArtist) {
    _isHairArtist = isHairArtist;
    print(_isHairArtist);
  }
}
