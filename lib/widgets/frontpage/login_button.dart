import 'package:flutter/material.dart';
import 'package:gel/providers/slideup_frontpage_provider.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../providers/text_size_provider.dart';

class Login extends StatelessWidget {
  const Login({
    Key? key,
    required PanelController panelController,
  })  : _panelController = panelController,
        super(key: key);

  final PanelController _panelController;
  @override
  Widget build(BuildContext context) {
    final _slideUpState =
        Provider.of<SlideUpStateProvider>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account?",
          style: Provider.of<FontSizeProvider>(context).bodyText3,
        ),
        GestureDetector(
          onTap: () => {
            _slideUpState.setFormOnPanel(AuthenticationForm.login),
            _panelController.open(),
          },
          child: Container(
            margin: EdgeInsets.all(3),
            child: Text(
              "Login",
              style: Provider.of<FontSizeProvider>(context).bodyText1,
            ),
          ),
        )
      ],
    );
  }
}
