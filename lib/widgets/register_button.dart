import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 50,
      margin: EdgeInsets.all(15),
      child: ElevatedButton(
        child: Text("Yo"),
        onPressed: () => {},
        style: ButtonStyle(
          splashFactory: NoSplash.splashFactory,
          backgroundColor: MaterialStateProperty.resolveWith(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                print("pressed");
                return Theme.of(context).accentColor;
              }
              return Theme.of(context).primaryColor;
            },
          ),
        ),
      ),
    );
  }
}
