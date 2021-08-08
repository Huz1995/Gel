import 'package:flutter/material.dart';
import 'package:gel/widgets/general/small_button.dart';

class New extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SmallButton(
          backgroundColor: Colors.blue,
          child: Text("Child"),
          buttonWidth: 150,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
