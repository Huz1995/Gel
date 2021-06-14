import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './screens/front_page.dart';

void main() {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blueAccent.shade700,
        accentColor: Colors.red.shade500,
        cardColor: Colors.grey.shade900,
        fontFamily: 'Poppins',
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          bodyText2: TextStyle(fontSize: 16.0),
          button: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
      ),
      home: FrontPage(),
    );
  }
}
