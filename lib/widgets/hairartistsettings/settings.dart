import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:provider/provider.dart';

import 'change_password.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _fontSizeProvider = Provider.of<FontSizeProvider>(context);
    final _authProvider = Provider.of<AuthenticationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, //change your color here
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        // backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Settings",
          style: _fontSizeProvider.headline3,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextButton(
              onPressed: () => {},
              child: Row(
                children: [
                  Text(
                    "Logout",
                    style: _fontSizeProvider.headline4,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                  ),
                  Icon(
                    MaterialIcons.keyboard_arrow_right,
                    color: Colors.black,
                    size: 30,
                  ),
                ],
              ),
            ),
          ),
          Divider(
            thickness: 3,
            indent: 13,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => ChangePasswordForm(
                        fontSizeProvider: _fontSizeProvider,
                        authenticationProvider: _authProvider),
                  ),
                );
              },
              child: Row(
                children: [
                  Text(
                    "Change Password",
                    style: _fontSizeProvider.headline4,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                  Icon(
                    MaterialIcons.keyboard_arrow_right,
                    color: Colors.black,
                    size: 30,
                  ),
                ],
              ),
            ),
          ),
          Divider(
            thickness: 3,
            indent: 13,
          ),
        ],
      ),
    );
  }
}
