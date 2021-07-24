import 'package:flutter/material.dart';

class RevampFormField extends StatelessWidget {
  RevampFormField({
    Key? key,
    required String fieldTitle,
    FocusNode? fieldFocusNode,
    FocusNode? nextFieldFocudNode,
    required bool obscureText,
    required void Function(String?)? onSaved,
    required String? Function(String?)? validator,
  })  : _fieldFocusNode = fieldFocusNode,
        _nextFieldFocusNode = nextFieldFocudNode,
        _fieldTitle = fieldTitle,
        _obscureText = obscureText,
        _onSaved = onSaved,
        _validator = validator,
        super(key: key);

  final FocusNode? _fieldFocusNode;
  final FocusNode? _nextFieldFocusNode;
  final String _fieldTitle;
  final bool _obscureText;
  final void Function(String?)? _onSaved;
  final String? Function(String?)? _validator;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        autocorrect: false,
        obscureText: _obscureText,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        focusNode: _fieldFocusNode,
        onSaved: _onSaved,
        validator: _validator,
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
