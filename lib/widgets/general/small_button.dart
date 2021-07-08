import 'package:flutter/material.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:provider/provider.dart';

class SmallButton extends StatelessWidget {
  const SmallButton(
      {Key? key,
      required Color backgroundColor,
      required Widget child,
      required double buttonWidth,
      required void Function() onPressed})
      : _backgroundColor = backgroundColor,
        _child = child,
        _onPressed = onPressed,
        _buttonWidth = buttonWidth,
        super(key: key);

  final Color _backgroundColor;
  final Widget _child;
  final void Function() _onPressed;
  final double _buttonWidth;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
        width: _buttonWidth,
        height: 40,
      ),
      child: ElevatedButton(
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
        child: _child,
      ),
    );
  }
}
