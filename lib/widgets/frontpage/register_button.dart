import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../providers/text_size_provider.dart';
import '../../providers/slideup_frontpage_provider.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({
    Key? key,
    required String buttonTitle,
    required bool isHairArtist,
    required PanelController panelController,
  })  : _buttonTitle = buttonTitle,
        _isHairArtist = isHairArtist,
        _panelController = panelController,
        super(key: key);

  final String _buttonTitle;
  final bool _isHairArtist;
  final PanelController _panelController;

  @override
  Widget build(BuildContext context) {
    final _slideUpState =
        Provider.of<SlideUpStateProvider>(context, listen: false);

    return Container(
      height: MediaQuery.of(context).size.width * .135,
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        MediaQuery.of(context).size.height * .03,
      ),
      child: ElevatedButton(
        child: Text(
          _buttonTitle,
          style: Provider.of<FontSizeProvider>(context).button,
        ),
        onPressed: () => {
          /*when the apprioate button is pressed will update formstate so
          the user has the appriopate form to register ie hair prof or user*/
          if (!_isHairArtist)
            {
              _slideUpState.setFormOnPanel(AuthenticationForm.userRegistration),
            }
          else
            {
              _slideUpState
                  .setFormOnPanel(AuthenticationForm.hairProfRegistration),
            },
          /*use the panel controller to open slide up panel*/
          _panelController.open(),
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
                    : Theme.of(context).accentColor.withOpacity(0.7);
              }
              return _isHairArtist
                  ? Theme.of(context).accentColor.withOpacity(0.7)
                  : Theme.of(context).primaryColor;
            },
          ),
        ),
      ),
    );
  }
}
