import 'package:flutter/material.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/widgets/small_button.dart';
import 'package:provider/provider.dart';

class HPdemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SmallButton(
          backgroundColor: Colors.blue,
          child: Text(
            "logout - hp",
            style: Provider.of<FontSize>(context).button,
          ),
          onPressed: () => {
            Navigator.of(context).pop(),
          },
        ),
      ),
    );
  }
}
