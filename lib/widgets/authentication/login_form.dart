import 'package:flutter/material.dart';
import 'package:gel/models/login_auth_model.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/slideup_frontpage_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/widgets/authentication/reset_password.dart';
import 'package:gel/widgets/general/long_button.dart';
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
    final _authenticationProvider =
        Provider.of<AuthenticationProvider>(context);
    final _fontSizeProvider = Provider.of<FontSizeProvider>(context);

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
        _authenticationProvider.loginEmailPassword(_loginData).then(
          (_) {
            Navigator.of(context).pop();
          },
        ).catchError(
          (onError) {
            errorValidation(onError);
          },
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.black,
        ),
      ),
      body: Container(
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
                          style: _fontSizeProvider.headline1,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: TextFormField(
                      autocorrect: false,
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
                      autocorrect: false,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Forgot Password? Click",
                        style: _fontSizeProvider.bodyText4,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider(
                                create: (context) => FontSizeProvider(context),
                                child: ResetPassword(
                                  authenticationProvider:
                                      _authenticationProvider,
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.all(3),
                          child: Text(
                            "Here",
                            style: Provider.of<FontSizeProvider>(context)
                                .bodyText1,
                          ),
                        ),
                      )
                    ],
                  ),
                  Spacer(),
                  LongButton(
                      backgroundColor: Theme.of(context).primaryColor,
                      onPressed: () => {
                            _saveForm(),
                          },
                      buttonName: "Log in"),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
