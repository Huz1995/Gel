import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account?",
          style: Theme.of(context).textTheme.bodyText2,
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
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        )
      ],
    );
  }
}
