import 'package:flutter/material.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/text_size_provider.dart';

class VerifyEmailWarning extends StatelessWidget {
  const VerifyEmailWarning({
    Key? key,
    required FontSizeProvider fontSizeProvider,
    required AuthenticationProvider authenticationProvider,
  })  : _fontSizeProvider = fontSizeProvider,
        _authenticationProvider = authenticationProvider,
        super(key: key);

  final FontSizeProvider _fontSizeProvider;
  final AuthenticationProvider _authenticationProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
              _authenticationProvider.emailVerifPeriodicTimer.cancel();
              _authenticationProvider.isEmailVerifController.close();
              _authenticationProvider.firebaseAuth.currentUser!.delete();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(50, 10, 50, 0),
        child: Text(
          "We have sent a link to your email address. Please click the link to verify the email or press cancel to stop the rergistration process",
          textAlign: TextAlign.center,
          style: _fontSizeProvider.bodyText4,
        ),
      ),
    );
  }
}
