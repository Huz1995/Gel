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

  TextStyle get bodyText1 {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.045,
      fontWeight: FontWeight.bold,
      color: Colors.blue.shade900,
    );
  }

  TextStyle get bodyText2 {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.04,
    );
  }
}
