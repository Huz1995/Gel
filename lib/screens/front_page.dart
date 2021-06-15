import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/register_button.dart';
import '../widgets/login_button.dart';
import '../widgets/gel_and_skip_row.dart';
import '../widgets/gel_definition.dart';
import '../providers/text_size_provider.dart';

class FrontPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FontSize(context),
      child: Scaffold(
        body: Center(
          child: Column(
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
              RegisterButton("Join.", false),
              RegisterButton("Join as Hair Artist.", true),
              Login(),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
