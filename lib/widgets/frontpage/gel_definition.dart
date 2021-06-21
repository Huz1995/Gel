import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';

import '../../providers/text_size_provider.dart';

class GelDefinition extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width * .85,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container(
          //   child: Text(
          //     "GEL",
          //     style: Provider.of<FontSize>(context).bodyText1,
          //   ),
          //   margin: EdgeInsets.only(
          //     bottom: 10,
          //   ),
          // ),
          SizedBox(
            height: 70,
            child: AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  "The GEL between you \n\nand your Hair Professional...",
                  textAlign: TextAlign.start,
                  textStyle: Provider.of<FontSize>(context).bodyText2,
                  speed: const Duration(milliseconds: 70),
                ),
              ],
              repeatForever: true,
            ),
          ),
        ],
      ),
    );
  }
}
