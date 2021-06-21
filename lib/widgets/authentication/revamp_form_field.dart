import 'package:flutter/material.dart';

class RevampFormField extends StatelessWidget {
  const RevampFormField({
    Key? key,
    required String fieldTitle,
    required FocusNode fieldFocusNode,
    required FocusNode nextFieldFocudNode,
    required bool obscureText,
  })  : _fieldFocusNode = fieldFocusNode,
        _nextFieldFocusNode = nextFieldFocudNode,
        _fieldTitle = fieldTitle,
        _obscureText = obscureText,
        super(key: key);

  final FocusNode _fieldFocusNode;
  final FocusNode _nextFieldFocusNode;
  final String _fieldTitle;
  final bool _obscureText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        obscureText: _obscureText,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        focusNode: _fieldFocusNode,
        onFieldSubmitted: (_) {
          FocusScope.of(context).unfocus();
          FocusScope.of(context).requestFocus(_nextFieldFocusNode);
        },
        decoration: InputDecoration(
          labelText: _fieldTitle,
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
        ),
      ),
    );
  }
}
