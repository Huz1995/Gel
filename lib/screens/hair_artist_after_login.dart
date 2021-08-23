import 'package:flutter/material.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:gel/providers/hair_client_profile_provider.dart';
import 'package:gel/widgets/general/bottom_nav_bar.dart';
import 'package:gel/widgets/general_profile/explore/hair_client_explore.dart';
import 'package:gel/widgets/hairartist/profile/hair_artist_profile_main_page.dart';
import 'package:gel/widgets/hairartist/settings/hair_artist_settings.dart';
import 'package:gel/widgets/messages/message_main_page_artist.dart';
import 'package:provider/provider.dart';

class HairArtistHomePage extends StatefulWidget {
  @override
  _HairArtistHomePageState createState() => _HairArtistHomePageState();
}

class _HairArtistHomePageState extends State<HairArtistHomePage> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    final _hairArtistProvider = Provider.of<HairArtistProfileProvider>(context);

    final List<Widget> _widgetOptions = <Widget>[
      HairClientExplore(isForClientRoute: false),
      MessagesMainPageArtitst(
        hairArtistProvider: _hairArtistProvider,
      ),
      HairArtistProfileMainPage(),
      HairArtistSettings(),
    ];

    void _onIconTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
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
    );
  }
}
