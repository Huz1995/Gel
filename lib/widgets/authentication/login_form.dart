import 'package:flutter/material.dart';
import 'package:gel/models/login_auth_model.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/slideup_frontpage_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/widgets/general/small_button.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  static final _formKey = GlobalKey<FormState>();
  final _loginData = LoginFormData();
  bool _wrongPassword = false;
  bool _userDoesntExist = false;
  bool _invalidEmail = false;
  bool _blockedAccount = false;

  @override
  Widget build(BuildContext context) {
    final _slideUpState = Provider.of<SlideUpStateProvider>(context);
    final _authenticationProvider =
        Provider.of<AuthenticationProvider>(context);
    /*detectes if the slide up panel is not active so deletes the form
    data and focusnode*/
    if (!_slideUpState.isSlideUpPanelOpen) {
      _formKey.currentState?.reset();
      FocusScope.of(context).unfocus();
    }

    void errorValidation(dynamic onError) {
      if (onError.toString() ==
          "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.") {
        _wrongPassword = true;
      } else if (onError.toString() ==
          "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.") {
        _userDoesntExist = true;
      } else if (onError.toString() ==
          "[firebase_auth/invalid-email] The email address is badly formatted.") {
        _invalidEmail = true;
      } else if (onError.toString() ==
          "[firebase_auth/too-many-requests] Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later.") {
        _blockedAccount = true;
      }
      _formKey.currentState?.validate();
      _wrongPassword = false;
      _userDoesntExist = false;
      _invalidEmail = false;
    }

    void _saveForm() {
      /*validate the form*/
      final isValid = _formKey.currentState?.validate();
      if (isValid!) {
        _formKey.currentState?.save();
        _authenticationProvider
            .loginUserIn(_loginData)
            .then((_) => _slideUpState.panelController.close())
            .catchError(
          (onError) {
            errorValidation(onError);
          },
        );
      }
    }

    return Container(
      child: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width / 15),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.02),
                      child: Text(
                        "Login",
                        style: Provider.of<FontSizeProvider>(context).headline1,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onSaved: (value) => {
                      _loginData.setEmail(value),
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Email field is blank";
                      } else if (_invalidEmail) {
                        return "This is not a real email address";
                      } else if (_userDoesntExist) {
                        return "User doesn't exist";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Email',
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextFormField(
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    onSaved: (value) => {
                      _loginData.setPassword(value),
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password field is empty";
                      } else if (_wrongPassword) {
                        return "Password is incorrect";
                      } else if (_blockedAccount) {
                        return "Password entered incorrectly - account blocked";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                    ),
                  ),
                ),
                SmallButton(
                  child: Text(
                    "Log in",
                    style: Provider.of<FontSizeProvider>(context).button,
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  onPressed: () => {
                    _saveForm(),
                  },
                  buttonWidth: 100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
