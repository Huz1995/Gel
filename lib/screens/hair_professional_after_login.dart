import 'package:flutter/material.dart';
import 'package:gel/widgets/small_button.dart';
import 'package:provider/provider.dart';

class HPdemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SmallButton(
          backgroundColor: Colors.blue,
          buttonTitle: "logout - hp",
          onPressed: () => {
            Navigator.of(context).pop(),
          },
        ),
      ),
    );
  }
}