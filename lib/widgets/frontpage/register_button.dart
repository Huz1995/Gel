import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../providers/text_size_provider.dart';
import '../../providers/slideup_frontpage_provider.dart';

class RegisterButton extends StatelessWidget {
  String _buttonTitle;
  bool _isHairArtist;
  PanelController _pc;

  RegisterButton(this._buttonTitle, this._isHairArtist, this._pc);

  @override
  Widget build(BuildContext context) {
    final _slideUpState = Provider.of<SlideUpState>(context, listen: false);

    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.height * .065,
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
        onPressed: () => {
          /*when the apprioate button is pressed will update formstate so
          the user has the appriopate form to register ie hair prof or user*/
          if (!_isHairArtist)
            {
              _slideUpState
                  .mapButtonEventToState(Authentication.userRegistration),
            }
          else
            {
              _slideUpState
                  .mapButtonEventToState(Authentication.hairProfRegistration),
            },
          /*use the panel controller to open slide up panel*/
          _pc.open(),
        },
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
                //if hair artist then main color is red and onclick is blue, vise versa"
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
