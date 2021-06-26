import 'package:flutter/material.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/widgets/small_button.dart';
import 'package:provider/provider.dart';

class HairArtistHomePage extends StatefulWidget {
  @override
  _HairArtistHomePageState createState() => _HairArtistHomePageState();
}

class _HairArtistHomePageState extends State<HairArtistHomePage> {
  int _selectedIndex = 3;

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
      Text(
        'Index 3: Profile',
      ),
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

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    print(_selectedIndex);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FontSize(context),
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
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            elevation: 100,
            items: const <BottomNavigationBarItem>[
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
                label: 'Profile',
                backgroundColor: Colors.purple,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
                backgroundColor: Colors.pink,
              ),
            ],
            onTap: _onItemTapped,
            currentIndex: _selectedIndex,
            selectedItemColor: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
