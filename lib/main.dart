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
      ),
      home: FrontPage(),
    );
  }
}
