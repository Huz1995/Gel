import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:gel/models/both_type_user_auth_model.dart';
import 'package:gel/models/login_auth_model.dart';
import 'package:gel/providers/custom_dialogs.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookSignIn = FacebookLogin();
  late StreamController<bool> _streamController;
  bool _isAuthenticating = false;
  late String? _idToken;
  bool _isLoggedIn = false;
  bool _isHairArtist = false;
  late Timer _logoutTimer;
  late Timer _emailVerifTimer;
  final GlobalKey<NavigatorState> navigatorKey;

  AuthenticationProvider(this.navigatorKey);
  /*heroku connection https://gel-backend.herokuapp.com*/
  Future<void> registerEmailPassword(UserRegisterFormData registerData) async {
    /*register the user with firebase auth and set the UID returned in register data*/
    await _auth.createUserWithEmailAndPassword(
      email: registerData.email!,
      password: registerData.password!,
    );
    /*after create user we need to send email verif link to the user*/
    try {
      await _auth.currentUser!.sendEmailVerification();
    } catch (e) {}
    /*function that perodically checks _auth to see if email is verif*/
    _waitingForUserToVerifiedEmail();
    /*init stream controller*/
    _streamController = StreamController();
    Stream boolStream = _streamController.stream;
    boolStream.listen(
      /*listen if the bool emit is true*/
      (userVerifedEmail) async {
        if (userVerifedEmail) {
          /*add the firebase uid to reg data model to send to backend*/
          /*send registration data to our api to store the user in mongoDb*/
          registerData.setUID(_auth.currentUser!.uid);
          await http.post(
            Uri.parse(
                "https://gel-backend.herokuapp.com/api/authentication/registration"),
            body: registerData.toObject(),
          );
          /*set isLogged in and hairArtist booleans so main.dart can render correct screen
          so user logs in after registration*/
          await _setFrontEndLoginStateAfterRegistration(registerData);
          navigatorKey.currentState!.pop();
          navigatorKey.currentState!.pop();
        }
      },
    );
  }

  /*function that perodically checks _auth to see if email is verif*/
  void _waitingForUserToVerifiedEmail() {
    _emailVerifTimer = Timer.periodic(
      Duration(seconds: 2),
      (_) async {
        /*reset the current user to refresh details*/
        await _auth.currentUser!.reload();
        if (_auth.currentUser!.emailVerified) {
          /*if verified add this state to the stream*/
          _streamController.add(true);
          /*once true close timer and stream*/
          _emailVerifTimer.cancel();
          _streamController.close();
        } else {
          _streamController.add(false);
        }
      },
    );
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

  /*function that registers user and stores in datbase after
  authenicated with google or facebook for the first time*/
  Future<void> _registerUser(String photoURL) async {
    UserRegisterFormData registerData = UserRegisterFormData();
    registerData.setEmail(_auth.currentUser!.email);
    registerData.setUID(_auth.currentUser!.uid);
    registerData.setIsHairArtist(_isHairArtist);
    registerData.setPhotoURL(photoURL);
    /*Send the data to the bak end*/
    var response = await http.get(
      Uri.parse("https://gel-backend.herokuapp.com/api/authentication/" +
          _auth.currentUser!.uid),
    );
    /*the data base will check is user is already registered and end response*/
    if (response.body == "User does not exist") {
      await http.post(
        Uri.parse(
            "https://gel-backend.herokuapp.com/api/authentication/registration"),
        body: registerData.toObject(),
      );
      /*set isLogged in and hairArtist booleans so main.dart can render correct screen
      so user logs in after registration*/
      await _setFrontEndLoginStateAfterRegistration(registerData);
    }
    /*else user has already registered so sign user out form 3rd party providers so can
    reg again and send a error to the ui using this provider function*/
    else {
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
    _logoutTimer = _logOutWhenTimerUp();
  }

  /*function that allows user to reg with google*/
  Future<void> googleRegistration(BuildContext context) async {
    final AuthCredential credential = await _googleGetAuthCredential();
    try {
      await _auth.signInWithCredential(credential);
    } catch (e) {
      throw e.toString();
    }
    try {
      CustomDialogs.authDiag(
        context: context,
        title: Text("Registering"),
        body: [Text("Please wait")],
      );
      await _registerUser(_auth.currentUser!.photoURL!);
      Navigator.of(context, rootNavigator: true).pop();
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      throw e.toString();
    }
  }

  /*function that allows user to reg with google*/
  Future<void> facebookRegistration(BuildContext context) async {
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
          CustomDialogs.authDiag(
            context: context,
            title: Text("Registering"),
            body: [Text("Please wait")],
          );
          await _registerUser(_auth.currentUser!.photoURL!);
          Navigator.of(context, rootNavigator: true).pop();
        } catch (e) {
          Navigator.of(context, rootNavigator: true).pop();
          throw e.toString();
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        throw (result.errorMessage);
    }
  }

  /*allows user to login with email and password*/
  Future<void> loginEmailPassword(LoginFormData loginData) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: loginData.email!, password: loginData.password!);
    } catch (e) {
      throw e.toString();
    }
    /*set the login state*/
    _isLoggedIn = true;
    _idToken = await _auth.currentUser!.getIdToken();
    /*need to query the database to see if user is hair artist or client logs in
      to render the correct screen*/
    var response = await http.get(
      Uri.parse("https://gel-backend.herokuapp.com/api/authentication/" +
          _auth.currentUser!.uid),
    );
    _isHairArtist = (response.body == 'true');
    /*notify the listeners listen to the changes in notifier atttributes*/
    notifyListeners();
    /*Firebase idToken expires in an hour so log usre out*/
    _logoutTimer = _logOutWhenTimerUp();
  }

  /*function that aids the user to login with 3rd party provider like google/fb*/
  Future<void> _loginUser() async {
    /*check if user exists in the back end before as google/fb will just login, need 
    to register first*/
    var response = await http.get(
      Uri.parse("https://gel-backend.herokuapp.com/api/authentication/" +
          _auth.currentUser!.uid),
    );
    /*if the user exists then log in the user*/
    if (response.body != "User does not exist") {
      _isHairArtist = (response.body == 'true');
      _isLoggedIn = true;
      _idToken = await _auth.currentUser!.getIdToken();
      /*notify the listeners listen to the changes in notifier atttributes*/
      notifyListeners();
      /*Firebase idToken expires in an hour so log usre out*/
      _logoutTimer = _logOutWhenTimerUp();
    }
    /*the user is not registered to reset and throw error*/
    else {
      _facebookSignIn.logOut();
      _googleSignIn.signOut();
      _auth.currentUser!.delete();
      throw "This account is not registered with Gel";
    }
  }

  /*function that logsin with google*/
  Future<void> loginWithGoogle(BuildContext context) async {
    final AuthCredential credential = await _googleGetAuthCredential();
    try {
      await _auth.signInWithCredential(credential);
    } catch (e) {
      throw e.toString();
    }
    try {
      CustomDialogs.authDiag(
        context: context,
        title: Text("Logging In"),
        body: [Text("Please wait")],
      );
      await _loginUser();
      Navigator.of(context, rootNavigator: true).pop();
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      throw e.toString();
    }
  }

  /*function that logs in with facebook*/
  Future<void> loginWithFacebook(BuildContext context) async {
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
          CustomDialogs.authDiag(
            context: context,
            title: Text("Logging In"),
            body: [Text("Please wait")],
          );
          await _loginUser();
          Navigator.of(context, rootNavigator: true).pop();
        } catch (e) {
          Navigator.of(context, rootNavigator: true).pop();
          throw e.toString();
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        throw (result.errorMessage);
    }
  }

  /*function that uses firebase to update their password*/
  Future<void> changePassword(String password) async {
    try {
      await _auth.currentUser!.updatePassword(password);
    } catch (e) {
      throw e.toString();
    }
  }

  /*if user forget password, firebase will set an email*/
  Future<void> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw e.toString();
    }
  }

  /*function that reset attributes in the provider so now user
  logs out*/
  Future<void> logUserOut() async {
    _isLoggedIn = false;
    _isHairArtist = false;
    _idToken = null;
    await _auth.signOut();
    _logoutTimer.cancel();
    await _googleSignIn.signOut();
    await _facebookSignIn.logOut();
    notifyListeners();
  }

  Timer _logOutWhenTimerUp() {
    return Timer(
      Duration(seconds: 3600),
      () async {
        await logUserOut();
      },
    );
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

  StreamController get isEmailVerifController {
    return _streamController;
  }

  void setIsHairArtist(bool isHairArtist) {
    _isHairArtist = isHairArtist;
  }

  Timer get emailVerifPeriodicTimer {
    return _emailVerifTimer;
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}
