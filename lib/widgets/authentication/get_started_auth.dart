import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:provider/provider.dart';

class GetStartedAuth extends StatelessWidget {
  const GetStartedAuth({
    Key? key,
    required bool isHairArtist,
  })  : _isHairArtist = isHairArtist,
        super(key: key);

  final bool _isHairArtist;

  @override
  Widget build(BuildContext context) {
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
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: AppleAuthButton(
            onPressed: () => {},
            style: AuthButtonStyle(
              borderRadius: 30,
              iconSize: 25,
              iconType: AuthIconType.secondary,
              buttonColor: Colors.black,
              elevation: 5,
              height: MediaQuery.of(context).size.width * .135,
              width: MediaQuery.of(context).size.width * 0.9,
              textStyle:
                  Provider.of<FontSizeProvider>(context).headline4_getStarted,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: FacebookAuthButton(
            onPressed: () => {},
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
          padding: const EdgeInsets.only(bottom: 15),
          child: GoogleAuthButton(
            onPressed: () => {},
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
          padding: const EdgeInsets.only(bottom: 15),
          child: EmailAuthButton(
            onPressed: () => {},
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
