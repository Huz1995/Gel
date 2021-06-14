import 'package:flutter/material.dart';

import '../widgets/register_button.dart';
import '../widgets/login_button.dart';
import '../widgets/gel_and_skip_row.dart';
import '../widgets/gel_definition.dart';

class FrontPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            GelAndSkip(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
            ),
            GelDefinition(),
            SizedBox(
              height: 25,
            ),
            RegisterButton("Join.", false),
            RegisterButton("Join as Hair Artist.", true),
            Login(),
          ],
        ),
      ),
    );
  }
}
