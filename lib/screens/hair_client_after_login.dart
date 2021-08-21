import 'package:flutter/material.dart';
import 'package:gel/providers/hair_client_profile_provider.dart';

import 'package:gel/widgets/general/bottom_nav_bar.dart';
import 'package:gel/widgets/general_profile/explore/hair_client_explore.dart';
import 'package:gel/widgets/hairclient/favourites/favourite_hair_artists.dart';
import 'package:gel/widgets/hairclient/settings/hair_client_settings.dart';
import 'package:gel/widgets/messages/message_main_page_client.dart';
import 'package:provider/provider.dart';

class HairClientHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _hairClientProvider = Provider.of<HairClientProfileProvider>(context);
    int _selectedIndex = _hairClientProvider.hairClientBottomNavBarState;

    final List<Widget> _widgetOptions = <Widget>[
      HairClientExplore(
        isForClientRoute: true,
      ),
      MessagesMainPageClient(),
      FavouriteHairArtists(),
      HairClientSettings(),
    ];

    void _onIconTapped(int index) {
      _hairClientProvider.setHairClientBottomNavBarState(index);
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
          isHairArtist: false,
        ),
      ),
    );
  }
}
