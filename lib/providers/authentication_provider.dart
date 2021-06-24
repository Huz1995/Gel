import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gel/models/both_type_user_auth_model.dart';
import 'package:gel/models/login_auth_model.dart';

class AuthenticationProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //register with email
  Future registerEmailPassword(UserRegisterFormData registerData) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: registerData.email!,
        password: registerData.password!,
      );
    } catch (e) {
      return Future.error(e);
    }
  }

  Future loginUserIn(LoginFormData loginData) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: loginData.email!, password: loginData.password!);
      print(result);
      _auth.signOut();
    } catch (e) {
      return Future.error(e);
    }
  }

  //sing out

}
