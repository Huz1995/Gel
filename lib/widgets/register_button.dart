import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  String _buttonTitle;
  bool _isHairArtist;

  RegisterButton(this._buttonTitle, this._isHairArtist);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 60,
      margin: EdgeInsets.all(20),
      child: ElevatedButton(
        child: Text(
          _buttonTitle,
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        onPressed: () => {},
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          splashFactory: NoSplash.splashFactory,
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                print("pressed");
                //if hair artist then main color is red and click is blue, vise versa
                return _isHairArtist
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).accentColor;
              }
              return _isHairArtist
                  ? Theme.of(context).accentColor
                  : Theme.of(context).primaryColor;
            },
          ),
        ),
      ),
    );
  }
}
