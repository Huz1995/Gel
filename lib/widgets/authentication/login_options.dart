import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/custom_dialogs.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/widgets/authentication/login_form.dart';
import 'package:provider/provider.dart';

class LoginOptions extends StatelessWidget {
  const LoginOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: FacebookAuthButton(
            text: "Login with Facebook",
            onPressed: () async {
              try {
                await _authenticationProvider.loginWithFacebook();
              } catch (e) {
                return CustomDialogs.showMyDialogOneButton(
                  context,
                  Text('Error'),
                  <Widget>[Text(e.toString())],
                  Text(
                    'Back',
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                  () {
                    Navigator.of(context).pop();
                  },
                );
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
                  return CustomDialogs.showMyDialogOneButton(
                    context,
                    Text('Error'),
                    <Widget>[Text(e.toString())],
                    Text(
                      'Back',
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                    () {
                      Navigator.of(context).pop();
                    },
                  );
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
              ),
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
