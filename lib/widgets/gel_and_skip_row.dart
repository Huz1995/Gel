import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/text_size_provider.dart';

class GelAndSkip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 30,
      ),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
          ),
          Text(
            "GEL",
            textScaleFactor: MediaQuery.of(context).textScaleFactor * 0.8,
            style: TextStyle(
              fontFamily: 'AttackGraffiti',
              fontSize: 80,
            ),
          ),
          Spacer(flex: 1),
          Container(
            height: MediaQuery.of(context).size.height * .06,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(
                context,
                '/map',
              ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (states) => Theme.of(context).cardColor.withOpacity(0.6),
                ),
              ),
              child: Text(
                "Skip",
                style: Provider.of<FontSize>(context).button,
              ),
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
