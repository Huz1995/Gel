import 'package:flutter/material.dart';

//proivder that sends font sized depending on the screen size
class FontSizeProvider extends ChangeNotifier {
  BuildContext context;

  FontSizeProvider(this.context);

  TextStyle get button {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.045,
      color: Colors.white,
    );
  }

  TextStyle get headline1 {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.08,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  TextStyle get headline2 {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.06,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  TextStyle get headline3 {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.05,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  TextStyle get headline4 {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.04,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  TextStyle get headline4_getStarted {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.04,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }

  TextStyle get bodyText1 {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.05,
      color: Theme.of(context).primaryColor,
    );
  }

  TextStyle get bodyText2 {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.035,
      color: Colors.white,
    );
  }

  TextStyle get bodyText3 {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.04,
      color: Colors.white,
    );
  }

  TextStyle get bodyText4 {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.04,
      color: Colors.black,
    );
  }

  TextStyle get bodyText1_white {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.06,
      color: Colors.white,
    );
  }
}
