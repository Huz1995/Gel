import 'package:flutter/material.dart';
import 'package:gel/widgets/general/small_button.dart';
import 'package:provider/provider.dart';

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
            width: MediaQuery.of(context).size.width * 0.05,
          ),
          Image(
            width: MediaQuery.of(context).size.width * 0.23,
            image: AssetImage("assets/images/logo.png"),
          ),
          Spacer(flex: 1),
          SmallButton(
            child: Text(
              "Skip",
              style: Provider.of<FontSizeProvider>(context).button,
            ),
            backgroundColor: Theme.of(context).cardColor,
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/map',
              );
            },
            buttonWidth: 65,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.05,
          ),
        ],
      ),
    );
  }
}
