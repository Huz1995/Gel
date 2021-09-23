import 'dart:ui';

import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/custom_dialogs.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:provider/provider.dart';

import 'hair_client_register_form.dart';
import 'hair_professional_register_form.dart';

class RegistrationOptions extends StatelessWidget {
  const RegistrationOptions({
    Key? key,
    required bool isHairArtist,
  })  : _isHairArtist = isHairArtist,
        super(key: key);

  final bool _isHairArtist;

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
          "Get Started",
          style: Provider.of<FontSizeProvider>(context).headline2,
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: FacebookAuthButton(
            onPressed: () async {
              try {
                await _authenticationProvider.facebookRegistration(context);
              } catch (error) {
                return CustomDialogs.showMyDialogOneButton(
                  context: context,
                  title: Text("Error"),
                  body: [Text(error.toString())],
                  buttonChild: Text('Back',
                      style: TextStyle(color: Theme.of(context).accentColor)),
                  buttonOnPressed: () async {
                    Navigator.of(context).pop();
                  },
                );
              }
            },
            text: "Register with Facebook",
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
            text: "Register with Google",
            onPressed: () async {
              try {
                await _authenticationProvider.googleRegistration(context);
              } catch (error) {
                if (error.toString() !=
                    "Null check operator used on a null value") {
                  return CustomDialogs.showMyDialogOneButton(
                    context: context,
                    title: Text("Error"),
                    body: [Text(error.toString())],
                    buttonChild: Text('Back',
                        style: TextStyle(color: Theme.of(context).accentColor)),
                    buttonOnPressed: () async {
                      Navigator.of(context).pop();
                    },
                  );
                }
              }
            },
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
            text: "Register with Email",
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                    create: (context) => FontSizeProvider(context),
                    child: _isHairArtist ? HProfRegForm() : NormRegForm(),
                  ),
                ),
              );
            },
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
