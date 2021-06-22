import 'package:flutter/material.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:provider/provider.dart';

class SmallButton extends StatelessWidget {
  const SmallButton(
      {Key? key,
      required Color backgroundColor,
      required String buttonTitle,
      required void Function() onPressed})
      : _backgroundColor = backgroundColor,
        _title = buttonTitle,
        _onPressed = onPressed,
        super(key: key);

  final Color _backgroundColor;
  final String _title;
  final void Function() _onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _onPressed,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (states) => _backgroundColor),
      ),
      child: Text(
        _title,
        style: Provider.of<FontSize>(context).button,
      ),
    );
  }
}
