import 'dart:ui';

import 'package:flutter/material.dart';

/*class that provides static methods that return 
and alter dialog with custoom titles, buttons, and on pressed functions*/

class CustomDialogs {
  static Future<void> showMyDialogTwoButtons({
    BuildContext? context,
    Widget? title,
    List<Widget>? body,
    Widget? buttonOnechild,
    void Function()? buttonOneOnPressed,
    Widget? buttonTwochild,
    void Function()? buttonTwoOnPressed,
  }) async {
    return showDialog<void>(
      context: context!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: title,
            content: SingleChildScrollView(
              child: Column(
                children: body!,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: buttonOnechild!,
                onPressed: buttonOneOnPressed,
              ),
              TextButton(
                child: buttonTwochild!,
                onPressed: buttonTwoOnPressed,
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> showMyDialogThreeButtons({
    BuildContext? context,
    Widget? title,
    List<Widget>? body,
    Widget? buttonOnechild,
    void Function()? buttonOneOnPressed,
    Widget? buttonTwochild,
    void Function()? buttonTwoOnPressed,
    Widget? buttonThreechild,
    void Function()? buttonThreeOnPressed,
  }) async {
    return showDialog<void>(
      context: context!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: title,
            content: SingleChildScrollView(
              child: Column(
                children: body!,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: buttonOnechild!,
                onPressed: buttonOneOnPressed,
              ),
              TextButton(
                child: buttonTwochild!,
                onPressed: buttonTwoOnPressed,
              ),
              TextButton(
                child: buttonThreechild!,
                onPressed: buttonThreeOnPressed,
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> showMyDialogOneButton({
    BuildContext? context,
    Widget? title,
    List<Widget>? body,
    Widget? buttonChild,
    void Function()? buttonOnPressed,
  }) async {
    return showDialog<void>(
      context: context!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: title,
            content: SingleChildScrollView(
              child: Column(
                children: body!,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: buttonChild!,
                onPressed: buttonOnPressed,
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> authDiag({
    BuildContext? context,
    Widget? title,
    List<Widget>? body,
  }) async {
    return showDialog<void>(
      context: context!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: title,
            content: SingleChildScrollView(
              child: Column(
                children: body!,
              ),
            ),
          ),
        );
      },
    );
  }
}
