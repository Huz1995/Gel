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

  TextStyle get bodyText1 {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.06,
      color: Theme.of(context).primaryColor,
    );
  }

  TextStyle get bodyText2 {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.05,
      color: Colors.white,
    );
  }
}
