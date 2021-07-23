import 'package:flutter/material.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:provider/provider.dart';

class LongButton extends StatelessWidget {
  const LongButton({
    Key? key,
    required Color backgroundColor,
    required void Function()? onPressed,
    required String buttonName,
  })  : _backgroundColor = backgroundColor,
        _onPressed = onPressed,
        _buttonName = buttonName,
        super(key: key);

  final Color _backgroundColor;
  final void Function()? _onPressed;
  final String _buttonName;

  @override
  Widget build(BuildContext context) {
    final _fontSizeProvider = Provider.of<FontSizeProvider>(context);

    return ElevatedButton(
      child: Text(
        _buttonName,
        style: _fontSizeProvider.button,
      ),
      onPressed: _onPressed,
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(
          Size(MediaQuery.of(context).size.width * 0.8,
              MediaQuery.of(context).size.height * 0.06),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        splashFactory: NoSplash.splashFactory,
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            return _backgroundColor;
          },
        ),
      ),
    );
  }
}
