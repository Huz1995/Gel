import 'package:flutter/material.dart';

//proivder that sends font sized depending on the screen size
class FontSize extends ChangeNotifier {
  BuildContext context;

  FontSize(this.context);

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
