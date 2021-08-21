import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/providers/ui_service.dart';
import 'package:gel/widgets/general/settings_button.dart';
import 'package:provider/provider.dart';
import 'package:app_settings/app_settings.dart';

import '../../general_profile/change_password.dart';

class HairArtistSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _fontSizeProvider = Provider.of<FontSizeProvider>(context);
    final _authProvider = Provider.of<AuthenticationProvider>(context);
    return Scaffold(
      appBar: UIService.generalAppBar(context, "Settings", null),
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
        ],
      ),
    );
  }
}
