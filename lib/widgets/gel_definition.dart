import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';

import '../providers/text_size_provider.dart';

class GelDefinition extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width * .75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              "gel",
              style: Provider.of<FontSize>(context).bodyText1,
            ),
            margin: EdgeInsets.only(
              bottom: 10,
            ),
          ),
          SizedBox(
            height: 70,
            child: RotateAnimatedTextKit(
                repeatForever: true,
                duration: const Duration(milliseconds: 5000),
                text: [
                  "verb: \ntake a definite form or begin to work well.",
                  "noun: \nis used to harden hair into a particular hairstyle.",
                ],
                textStyle: Provider.of<FontSize>(context).bodyText2,
                textAlign: TextAlign.start,
                alignment: AlignmentDirectional.topStart // or Alignment.topLeft
                ),
          ),
        ],
      ),
    );
  }
}
