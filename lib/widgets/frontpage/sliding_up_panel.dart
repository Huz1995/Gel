import 'package:flutter/material.dart';
import 'package:gel/widgets/authentication/login_options.dart';
import 'package:gel/widgets/authentication/registration_options.dart';
import 'package:provider/provider.dart';

import './register_button.dart';
import './login_button.dart';
import './gel_and_skip_row.dart';
import './gel_definition.dart';
import 'package:gel/providers/slideup_frontpage_provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingUpPanelFrontPage extends StatelessWidget {
  const SlidingUpPanelFrontPage({
    Key? key,
    required PanelController panelController,
  })  : _panelController = panelController,
        super(key: key);

  final PanelController _panelController;

  @override
  Widget build(BuildContext context) {
    final _slideUpPanelProvider = Provider.of<SlideUpStateProvider>(context);

    Widget _slideUpPanelDisplayWidget() {
      if (_slideUpPanelProvider.formState.userRegistration) {
        return RegistrationOptions(
          isHairArtist: false,
        );
      } else if (_slideUpPanelProvider.formState.hairProfRegistration) {
        return RegistrationOptions(
          isHairArtist: true,
        );
      } else {
        return LoginOptions();
      }
    }

    return SlidingUpPanel(
      boxShadow: [
        BoxShadow(blurRadius: 50, color: Colors.grey),
      ],
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      controller: _panelController,
      minHeight: 0,
      maxHeight: MediaQuery.of(context).size.width,
      panel: Center(
        /*consumer is listening to the changes in formstate and rebuils 
        appropiate form on the slide up panel*/
        child: _slideUpPanelDisplayWidget(),
      ),
      /*this is the background widget that is behind the slide
      up panel*/
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          GelAndSkip(),
          Expanded(
            child: Container(),
          ),
          GelDefinition(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.015,
          ),
          RegisterButton(
            buttonTitle: "Join.",
            isHairArtist: false,
            panelController: _panelController,
          ),
          RegisterButton(
              buttonTitle: "Join as Hair Artist.",
              isHairArtist: true,
              panelController: _panelController),
          Login(panelController: _panelController),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
