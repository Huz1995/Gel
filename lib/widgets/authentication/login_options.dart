import 'dart:ui';

import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/widgets/authentication/login_form.dart';
import 'package:provider/provider.dart';

class LoginOptions extends StatelessWidget {
  const LoginOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _showMyDialog(String error) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: Text('Error'),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text(error),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'Back',
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    final _authenticationProvider =
        Provider.of<AuthenticationProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.04,
        ),
        Text(
          "Login",
          style: Provider.of<FontSizeProvider>(context).headline2,
        ),
        SizedBox(height: 20),
        // Padding(
        //   padding: const EdgeInsets.only(bottom: 20),
        //   child: AppleAuthButton(
        //     onPressed: () => {},
        //     text: "Login with Apple",
        //     style: AuthButtonStyle(
        //       borderRadius: 30,
        //       iconSize: 25,
        //       iconType: AuthIconType.secondary,
        //       buttonColor: Colors.black,
        //       elevation: 5,
        //       height: MediaQuery.of(context).size.width * .135,
        //       width: MediaQuery.of(context).size.width * 0.9,
        //       textStyle:
        //           Provider.of<FontSizeProvider>(context).headline4_getStarted,
        //     ),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: FacebookAuthButton(
            text: "Login with Facebook",
            onPressed: () async {
              try {
                await _authenticationProvider.loginWithFacebook();
              } catch (e) {
                return _showMyDialog(e.toString());
              }
            },
            style: AuthButtonStyle(
              iconSize: 25,
              borderRadius: 30,
              elevation: 5,
              height: MediaQuery.of(context).size.width * .135,
              width: MediaQuery.of(context).size.width * 0.9,
              textStyle:
                  Provider.of<FontSizeProvider>(context).headline4_getStarted,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: GoogleAuthButton(
            onPressed: () async {
              try {
                await _authenticationProvider.loginWithGoogle();
              } catch (e) {
                String errMsg = e.toString();
                if (errMsg != "Null check operator used on a null value") {
                  return _showMyDialog(e.toString());
                }
              }
            },
            text: "Login with Google",
            style: AuthButtonStyle(
              iconSize: 25,
              borderRadius: 30,
              elevation: 5,
              height: MediaQuery.of(context).size.width * .135,
              width: MediaQuery.of(context).size.width * 0.9,
              textStyle: Provider.of<FontSizeProvider>(context).headline4,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: EmailAuthButton(
            onPressed: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                    create: (context) => FontSizeProvider(context),
                    child: LoginForm(),
                  ),
                ),
              )
            },
            text: "Login with Email",
            style: AuthButtonStyle(
              buttonColor: Theme.of(context).primaryColor,
              iconSize: 25,
              borderRadius: 30,
              elevation: 5,
              height: MediaQuery.of(context).size.width * .135,
              width: MediaQuery.of(context).size.width * 0.9,
              textStyle:
                  Provider.of<FontSizeProvider>(context).headline4_getStarted,
            ),
          ),
        ),
      ],
    );
  }
}
