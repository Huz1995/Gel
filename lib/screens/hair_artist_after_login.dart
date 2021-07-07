import 'package:flutter/material.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/widgets/general/bottom_nav_bar.dart';
import 'package:gel/widgets/general/small_button.dart';
import 'package:gel/widgets/hairartistprofile/hair_artist_profile_main_page.dart';
import 'package:provider/provider.dart';

class HairArtistHomePage extends StatefulWidget {
  @override
  _HairArtistHomePageState createState() => _HairArtistHomePageState();
}

class _HairArtistHomePageState extends State<HairArtistHomePage> {
  int _selectedIndex = 2;

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
      SmallButton(
        backgroundColor: Colors.red,
        child: Text(
          "logout - hp",
        ),
        onPressed: () {
          _authProvider.logUserOut();
        },
      ),
    ];

    void _onIconTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FontSizeProvider(context),
        ),
        ChangeNotifierProvider(
          create: (context) => HairArtistProfileProvider(_authProvider),
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
          ),
        ),
      ),
    );
  }
}
