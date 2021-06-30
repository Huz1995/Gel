import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './register_button.dart';
import './login_button.dart';
import './gel_and_skip_row.dart';
import './gel_definition.dart';
import '../authentication/hair_professional_register_form.dart';
import 'package:gel/providers/slideup_frontpage_provider.dart';
import 'package:gel/widgets/authentication/login_form.dart';
import 'package:gel/widgets/authentication/hair_client_register_form.dart';
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
    final _slideUpPanel = Provider.of<SlideUpStateProvider>(context);
    return SlidingUpPanel(
      onPanelClosed: () => _slideUpPanel.setPanelState(Panel.closed),
      onPanelOpened: () => _slideUpPanel.setPanelState(Panel.open),
      boxShadow: [
        BoxShadow(blurRadius: 50, color: Colors.grey),
      ],
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(50),
        topRight: Radius.circular(50),
      ),
      controller: _panelController,
      minHeight: 0,
      maxHeight: MediaQuery.of(context).size.height * 11 / 12,
      panel: Center(
        /*consumer is listening to the changes in formstate and rebuils 
        appropiate form on the slide up panel*/
        child: Consumer<SlideUpStateProvider>(
          builder: (context, value, child) {
            if (value.formState.userRegistration) {
              return NormRegForm();
            } else if (value.formState.hairProfRegistration) {
              return HProfRegForm();
            } else {
              return LoginForm();
            }
          },
        ),
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
