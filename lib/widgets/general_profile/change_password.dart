import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/custom_dialogs.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/widgets/authentication/revamped_form_field.dart';
import 'package:provider/provider.dart';

class ChangePasswordForm extends StatelessWidget {
  ChangePasswordForm(
      {Key? key,
      required FontSizeProvider fontSizeProvider,
      required AuthenticationProvider authenticationProvider})
      : _fontSizeProvider = fontSizeProvider,
        _authenticationProvider = authenticationProvider,
        super(key: key);

  final FontSizeProvider _fontSizeProvider;
  final AuthenticationProvider _authenticationProvider;
  static final _formKey = GlobalKey<FormState>();
  String _password = "";

  @override
  Widget build(BuildContext context) {
    /*to ensure when auto logout occurs then we remove this widget the tree*/
    if (!_authenticationProvider.isLoggedIn) {
      Timer(
        Duration(seconds: 1),
        () {
          Navigator.of(context).pop();
        },
      );
    }
    void _onChangePassword() {
      if (_formKey.currentState!.validate()) {
        _authenticationProvider.changePassword(_password).then(
          (_) async {
            await CustomDialogs.showMyDialogOneButton(
              context,
              Text("Success"),
              [Text("Password has been changed")],
              Text("ok"),
              () {
                Navigator.of(context).pop();
              },
            ).then(
              (_) => Navigator.of(context).pop(),
            );
          },
        ).catchError(
          /*maybe need to do something with this error*/
          (error) => print(error),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, //change your color here
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        // backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Change Password",
          style: _fontSizeProvider.headline3,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width / 15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              RevampFormField(
                fieldTitle: "Password",
                obscureText: true,
                onSaved: (value) => {},
                validator: (value) {
                  if (value!.length <= 8) {
                    return "Password has to have more then 7 characters";
                  }
                  _password = value;
                },
              ),
              RevampFormField(
                fieldTitle: "Repeat Password",
                obscureText: true,
                onSaved: (value) => print(value),
                validator: (value) {
                  if (value != _password) {
                    return "Passwords do not match";
                  }
                },
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  child: Text(
                    "Change Password",
                    style: _fontSizeProvider.button,
                  ),
                  onPressed: _onChangePassword,
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                      Size(MediaQuery.of(context).size.width * 0.8,
                          MediaQuery.of(context).size.height * 0.06),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    splashFactory: NoSplash.splashFactory,
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return Theme.of(context).primaryColor;
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
