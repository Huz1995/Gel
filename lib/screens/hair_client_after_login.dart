import 'package:flutter/material.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/hair_client_profile_provider.dart';
import 'package:gel/providers/map_hair_artists_retrieval.dart';
import 'package:gel/providers/map_places_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/widgets/general/bottom_nav_bar.dart';
import 'package:gel/widgets/hairclient/explore/hair_client_explore.dart';
import 'package:gel/widgets/hairclient/favourites/favourite_hair_artists.dart';
import 'package:gel/widgets/hairclient/settings/hair_client_settings.dart';
import 'package:gel/widgets/messages/message_main_page.dart';
import 'package:provider/provider.dart';

class HairClientHomePage extends StatefulWidget {
  @override
  _HairClientHomePageState createState() => _HairClientHomePageState();
}

class _HairClientHomePageState extends State<HairClientHomePage> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthenticationProvider>(context);

    final List<Widget> _widgetOptions = <Widget>[
      HairClientExplore(),
      MessagesMainPage(),
      FavouriteHairArtists(),
      HairClientSettings(),
    ];

    void _onIconTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HairClientProfileProvider(_authProvider),
        ),
        ChangeNotifierProvider(
          create: (context) => FontSizeProvider(context),
        ),
        ChangeNotifierProvider(
          create: (context) => MapPlacesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MapHairArtistRetrievalProvider(_authProvider),
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
            isHairArtist: false,
          ),
        ),
      ),
    );
  }
}
