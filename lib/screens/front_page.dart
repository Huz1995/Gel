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
            Row(
              children: [
                Spacer(flex: 1),
                Text("Skip"),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * (6 / 10),
            ),
            RegisterButton("Join.", false),
            RegisterButton("Join as Hair Artist.", true),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
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
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
