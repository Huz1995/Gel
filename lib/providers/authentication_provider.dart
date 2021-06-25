import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gel/models/both_type_user_auth_model.dart';
import 'package:gel/models/login_auth_model.dart';
import 'package:http/http.dart' as http;

class AuthenticationProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //register with email
  Future registerEmailPassword(UserRegisterFormData registerData) async {
    /*register the user with firebase auth and set the UID returned in register data*/
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: registerData.email!,
        password: registerData.password!,
      );
      registerData.setUID(result.user!.uid);
      print(result.user!.uid);
    } catch (e) {
      return Future.error(e);
    }
    /*send registration data to our api to store the user in mongoDb*/
    try {
      var response = await http.post(
        Uri.parse("http://localhost:3000/api/user/registration"),
        body: registerData.userObject(),
      );
      print(response.body);
    } catch (e) {
      print(e);
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
