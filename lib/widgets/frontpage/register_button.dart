import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../providers/text_size_provider.dart';

class RegisterButton extends StatelessWidget {
  String _buttonTitle;
  bool _isHairArtist;
  PanelController _pc;

  RegisterButton(this._buttonTitle, this._isHairArtist, this._pc);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .75,
      height: MediaQuery.of(context).size.height * .075,
      margin: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        MediaQuery.of(context).size.height * .03,
      ),
      child: ElevatedButton(
        child: Text(
          _buttonTitle,
          style: Provider.of<FontSize>(context).button,
        ),
        onPressed: () => {_pc.open()},
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
                //if hair artist then main color is red and click is blue, vise versa"
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
