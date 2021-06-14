import 'package:flutter/material.dart';

class GelAndSkip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 50,
      ),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.13,
          ),
          Container(
            margin: EdgeInsets.only(
              top: 20,
            ),
            child: Text(
              "GEL",
              style: TextStyle(
                fontFamily: 'AttackGraffiti',
                fontSize: 80,
              ),
            ),
          ),
          Spacer(flex: 1),
          FloatingActionButton(
            onPressed: () => print("Skip"),
            backgroundColor: Theme.of(context).cardColor.withOpacity(0.6),
            child: Text(
              "Skip",
              style: Theme.of(context).textTheme.button,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
          ),
        ],
      ),
    );
  }
}
