import 'package:flutter/material.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/custom_dialogs.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/widgets/general/bottom_nav_bar.dart';
import 'package:gel/widgets/hairartist/profile/hair_artist_profile_main_page.dart';
import 'package:gel/widgets/hairartist/settings/hair_artist_settings.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class HairArtistHomePage extends StatefulWidget {
  @override
  _HairArtistHomePageState createState() => _HairArtistHomePageState();
}

class _HairArtistHomePageState extends State<HairArtistHomePage> {
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    print("dffd");

    Geolocator.checkPermission().then(
      (value) {
        if (value == LocationPermission.denied ||
            value == LocationPermission.deniedForever) {
          Geolocator.requestPermission().then(
            (value) {
              if (value == LocationPermission.denied ||
                  value == LocationPermission.deniedForever) {
                CustomDialogs.showMyDialogOneButton(
                  context,
                  Text("Warning"),
                  [
                    Text(
                        "In order for people in you area to discover your services, you will need to add location services, in settings you can update your location services"),
                  ],
                  Text("Ok"),
                  () {
                    Navigator.of(context).pop();
                  },
                );
                print(
                    "In order for people in you area to discover your services, you will need to add location services, in settings you can update your location services");
              }
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthenticationProvider>(context);

    final List<Widget> _widgetOptions = <Widget>[
      Text(
        'Index 1: Explore',
      ),
      Text(
        'Index 2: Messages',
      ),
      HairArtistProfileMainPage(),
      HairArtistSettings(),
    ];

    void _onIconTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            return FontSizeProvider(context);
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return HairArtistProfileProvider(_authProvider);
          },
        ),
      ],
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 5,
              ),
            ],
          ),
          child: BottomNavBar(
            selectedIndex: _selectedIndex,
            onIconTapped: _onIconTapped,
            isHairArtist: true,
          ),
        ),
      ),
    );
  }
}
