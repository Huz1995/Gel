import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key? key,
    required int selectedIndex,
    required void Function(int)? onIconTapped,
    required bool isHairArtist,
  })  : _selectedIndex = selectedIndex,
        _onIconTapped = onIconTapped,
        _isHairArtist = isHairArtist,
        super(key: key);

  final int _selectedIndex;
  final bool _isHairArtist;
  final void Function(int)? _onIconTapped;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      elevation: 100,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message_outlined),
          label: 'Messages',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.face),
          label: _isHairArtist ? "Profile" : "Favorites",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      onTap: _onIconTapped,
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black.withOpacity(0.5),
    );
  }
}
