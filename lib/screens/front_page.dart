import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../widgets/frontpage/register_button.dart';
import '../widgets/frontpage/login_button.dart';
import '../widgets/frontpage/gel_and_skip_row.dart';
import '../widgets/frontpage/gel_definition.dart';
import '../providers/text_size_provider.dart';
import '../widgets/authentication/hp_reg_form.dart';

class FrontPage extends StatelessWidget {
  final PanelController _pc = new PanelController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FontSize(context),
      child: Scaffold(
        body: Center(
          child: SlidingUpPanel(
            boxShadow: [
              BoxShadow(blurRadius: 50, color: Colors.grey),
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
            controller: _pc,
            minHeight: 0,
            maxHeight: MediaQuery.of(context).size.height * 2 / 3,
            panel: Center(
              child: HProfRefForm(),
            ),
            body: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                GelAndSkip(_pc),
                Expanded(
                  child: Container(),
                ),
                GelDefinition(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                RegisterButton("Join.", false, _pc),
                RegisterButton("Join as Hair Artist.", true, _pc),
                Login(),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
