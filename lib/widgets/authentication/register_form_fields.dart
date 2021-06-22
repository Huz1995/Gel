import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:gel/models/both_type_user_auth_model.dart';
import 'package:gel/providers/slideup_frontpage_provider.dart';
import 'package:gel/widgets/authentication/revamped_form_field.dart';
import 'package:gel/widgets/small_button.dart';
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
  final authData = BothTypeUserAuthData();
  /*used to store entered password for validation*/
  late String _password;

  @override
  Widget build(BuildContext context) {
    final slideUpState = Provider.of<SlideUpState>(context);

    void _saveForm() {
      /*validate the form*/
      final isValid = widget._formKey.currentState?.validate();
      if (isValid!) {
        widget._formKey.currentState?.save();
        slideUpState.panelController.close();
        slideUpState.mapButtonEventToState(Authentication.login);
        Timer(
          Duration(seconds: 1),
          () => {
            slideUpState.panelController.open(),
          },
        );
      }
    }

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
            onSaved: (value) => {
              authData.setUsername(value),
            },
            validator: (value) {
              if (value!.length < 2) {
                return "Please enter a username greater then two characters";
              }
              return null;
            },
          ),
          RevampFormField(
            fieldTitle: "Email",
            fieldFocusNode: _emailFocusNode,
            nextFieldFocudNode: _passwordFocusNode,
            obscureText: false,
            onSaved: (value) => {
              authData.setEmail(value),
            },
            validator: (value) {
              if (!EmailValidator.validate(value!, true, true)) {
                return "Please enter a valid email address";
              }
              return null;
            },
          ),
          RevampFormField(
            fieldTitle: "Password",
            fieldFocusNode: _passwordFocusNode,
            nextFieldFocudNode: _rpasswordFocusNode,
            obscureText: true,
            onSaved: (value) => {
              authData.setPassword(value),
            },
            validator: (value) {
              if (value!.length <= 8) {
                return "Password has to have more then 7 characters";
              }
              _password = value;
              return null;
            },
          ),
          RevampFormField(
            fieldTitle: "Repeat Password",
            fieldFocusNode: _rpasswordFocusNode,
            nextFieldFocudNode: FocusNode(),
            obscureText: true,
            onSaved: (value) => {},
            validator: (value) {
              if (_password != value) {
                return "Passwords do not match";
              }
              return null;
            },
          ),
          SmallButton(
            buttonTitle: "Submit",
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () => {
              FocusScope.of(context).unfocus(),
              _saveForm(),
            },
          ),
        ],
      ),
    );
  }
}
