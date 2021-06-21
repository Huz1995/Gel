import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './register_button.dart';
import './login_button.dart';
import './gel_and_skip_row.dart';
import './gel_definition.dart';
import '../authentication/hp_reg_form.dart';
import 'package:gel/providers/slideup_frontpage_provider.dart';
import 'package:gel/widgets/authentication/login_form.dart';
import 'package:gel/widgets/authentication/norm_reg_form.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingUpPanelFrontPage extends StatelessWidget {
  final PanelController _pc;
  SlidingUpPanelFrontPage(this._pc);

  @override
  Widget build(BuildContext context) {
    final _slideUpPanel = Provider.of<SlideUpState>(context);
    return SlidingUpPanel(
      onPanelClosed: () => _slideUpPanel.setSlideUpPanelActive(false),
      onPanelOpened: () => _slideUpPanel.setSlideUpPanelActive(true),
      boxShadow: [
        BoxShadow(blurRadius: 50, color: Colors.grey),
      ],
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(50),
        topRight: Radius.circular(50),
      ),
      controller: _pc,
      minHeight: 0,
      maxHeight: MediaQuery.of(context).size.height * 11 / 12,
      panel: Center(
        /*consumer is listening to the changes in formstate and rebuils 
        appropiate form on the slide up panel*/
        child: Consumer<SlideUpState>(
          builder: (context, value, child) {
            if (value.formState.userReg) {
              return NormRegForm();
            } else if (value.formState.hpReg) {
              return HProfRefForm();
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
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          RegisterButton("Join.", false, _pc),
          RegisterButton("Join as Hair Artist.", true, _pc),
          Login(_pc),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
