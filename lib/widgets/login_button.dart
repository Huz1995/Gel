import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/text_size_provider.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account?",
          style: Provider.of<FontSize>(context).bodyText2,
        ),
        GestureDetector(
          onTap: () => {
            print(
              "Gone to login",
            ),
          },
          child: Container(
            margin: EdgeInsets.all(3),
            child: Text(
              "Login",
              style: Provider.of<FontSize>(context).bodyText1,
            ),
          ),
        )
      ],
    );
  }
}
