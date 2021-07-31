import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gel/providers/text_size_provider.dart';

class SettingButton extends StatelessWidget {
  const SettingButton(
      {Key? key,
      required void Function()? onPressed,
      required FontSizeProvider fontSizeProvider,
      required double gap,
      required String title,
      required})
      : _onPressed = onPressed,
        _fontSizeProvider = fontSizeProvider,
        _gap = gap,
        _title = title,
        super(key: key);

  final void Function()? _onPressed;
  final FontSizeProvider _fontSizeProvider;
  final double _gap;
  final String _title;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: TextButton(
            onPressed: _onPressed,
            child: Row(
              children: [
                Text(
                  _title,
                  style: _fontSizeProvider.headline4,
                ),
                SizedBox(
                  width: _gap,
                ),
                Icon(
                  MaterialIcons.keyboard_arrow_right,
                  color: Colors.black,
                  size: 30,
                ),
              ],
            ),
          ),
        ),
        Divider(
          thickness: 3,
          indent: 13,
        ),
      ],
    );
  }
}
