import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/widgets/general/settings_button.dart';
import 'package:gel/widgets/general_profile/change_password.dart';
import 'package:provider/provider.dart';
import 'package:app_settings/app_settings.dart';

class HairClientSettings extends StatelessWidget {
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
          SettingButton(
            onPressed: () => _authProvider.logUserOut(),
            title: "Logout",
            fontSizeProvider: _fontSizeProvider,
            gap: MediaQuery.of(context).size.width * 0.7,
          ),
          SettingButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => ChangePasswordForm(
                      fontSizeProvider: _fontSizeProvider,
                      authenticationProvider: _authProvider),
                ),
              );
            },
            title: "Change Password",
            fontSizeProvider: _fontSizeProvider,
            gap: MediaQuery.of(context).size.width * 0.5,
          ),
          SettingButton(
            onPressed: () async {
              await AppSettings.openLocationSettings();
            },
            title: "Open Location Settings",
            fontSizeProvider: _fontSizeProvider,
            gap: MediaQuery.of(context).size.width * 0.41,
          ),
          SettingButton(
            onPressed: () async {
              await AppSettings.openLocationSettings();
            },
            title: "Edit Profile",
            fontSizeProvider: _fontSizeProvider,
            gap: MediaQuery.of(context).size.width * 0.64,
          ),
        ],
      ),
    );
  }
}
