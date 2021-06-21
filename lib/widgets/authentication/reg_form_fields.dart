import 'package:flutter/material.dart';
import 'package:gel/widgets/authentication/revamp_form_field.dart';
import 'package:gel/widgets/frontpage/small_button.dart';
import 'package:provider/provider.dart';

import '../../providers/text_size_provider.dart';

class RegisterFormFields extends StatefulWidget {
  RegisterFormFields({
    Key? key,
    required GlobalKey<FormState> formKey,
    required String formTitle,
    required bool isHairArtist,
  })  : _formKey = formKey,
        _formTitle = formTitle,
        _isHairArtist = isHairArtist,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final String _formTitle;
  final bool _isHairArtist;

  @override
  _RegisterFormFieldsState createState() => _RegisterFormFieldsState();
}

class _RegisterFormFieldsState extends State<RegisterFormFields> {
  final _usernameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _rpasswordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width / 15),
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.02),
                child: Text(
                  widget._formTitle,
                  style: Provider.of<FontSize>(context).headline1,
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
          RevampFormField(
            fieldTitle: "Username",
            fieldFocusNode: _usernameFocusNode,
            nextFieldFocudNode: _emailFocusNode,
            obscureText: false,
          ),
          RevampFormField(
            fieldTitle: "Email",
            fieldFocusNode: _emailFocusNode,
            nextFieldFocudNode: _passwordFocusNode,
            obscureText: false,
          ),
          RevampFormField(
            fieldTitle: "Password",
            fieldFocusNode: _passwordFocusNode,
            nextFieldFocudNode: _rpasswordFocusNode,
            obscureText: true,
          ),
          RevampFormField(
            fieldTitle: "Repeat Password",
            fieldFocusNode: _rpasswordFocusNode,
            nextFieldFocudNode: FocusNode(),
            obscureText: true,
          ),
          SmallButton(
            buttonTitle: "Submit",
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () => {
              FocusScope.of(context).unfocus(),
              print("submit"),
            },
          ),
        ],
      ),
    );
  }
}
