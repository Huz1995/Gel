import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/hair_client_profile_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/providers/ui_service.dart';
import 'package:gel/widgets/general/settings_button.dart';
import 'package:gel/widgets/general_profile/change_password.dart';
import 'package:gel/widgets/hairclient/settings/edit_hair_client_profile_form.dart';
import 'package:provider/provider.dart';
import 'package:app_settings/app_settings.dart';
import 'package:rating_dialog/rating_dialog.dart';

class HairClientSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _fontSizeProvider = Provider.of<FontSizeProvider>(context);
    final _authProvider = Provider.of<AuthenticationProvider>(context);

    final _hairClientProfileProvider =
        Provider.of<HairClientProfileProvider>(context, listen: true);
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
          SettingButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => EditHairClientProfileForm(
                      _fontSizeProvider, _hairClientProfileProvider),
                ),
              );
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
