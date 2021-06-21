import 'package:flutter/material.dart';
import 'package:gel/providers/slideup_frontpage_provider.dart';
import 'package:gel/widgets/frontpage/small_button.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../providers/text_size_provider.dart';

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
            width: MediaQuery.of(context).size.width * 0.075,
          ),
          Image(
            width: MediaQuery.of(context).size.width * 0.2,
            image: AssetImage("assets/images/logo.png"),
          ),
          Spacer(flex: 1),
          SmallButton(
            buttonTitle: "Skip",
            backgroundColor: Theme.of(context).cardColor,
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/map',
              );
            },
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.075,
          ),
        ],
      ),
    );
  }
}
