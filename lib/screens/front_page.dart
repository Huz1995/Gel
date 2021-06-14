import 'package:flutter/material.dart';

import '../widgets/register_button.dart';

class FrontPage extends StatelessWidget {
  const FrontPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 2),
            RegisterButton(),
            RegisterButton()
          ],
        ),
      ),
    );
  }
}
