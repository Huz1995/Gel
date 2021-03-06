import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gel/screens/hair_artist_providers_init.dart';
import 'package:gel/screens/hair_client_providers_init.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import './screens/front_page.dart';
import 'package:gel/screens/unauth_map_page.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitDown,
    ]);
    final GlobalKey<NavigatorState> navigatorKey =
        new GlobalKey<NavigatorState>();

    return ChangeNotifierProvider(
      create: (context) => AuthenticationProvider(navigatorKey),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        title: 'Gel',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.blueAccent.shade700,
          accentColor: Colors.red.shade500,
          cardColor: Colors.grey.shade800,
          //textTheme: GoogleFonts.questrialTextTheme(),
          fontFamily: 'Questrial',
        ),
        home: Consumer<AuthenticationProvider>(
          builder: (context, value, child) {
            if (value.isLoggedIn && value.isHairArtist) {
              return HairArtistProviders();
            } else if (value.isLoggedIn && !value.isHairArtist) {
              return HairClientProviders();
            } else {
              return FrontPage();
            }
          },
        ),
        routes: {
          '/landing': (context) => FrontPage(),
          '/map': (context) => MapPage(),
        },
      ),
    );
  }
}
