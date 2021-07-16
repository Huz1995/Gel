import 'package:flutter/material.dart';
import 'package:gel/models/both_type_user_auth_model.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/slideup_frontpage_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/widgets/authentication/revamped_form_field.dart';
import 'package:gel/widgets/general/small_button.dart';
import 'package:provider/provider.dart';

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
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _rpasswordFocusNode = FocusNode();
  final _registerData = UserRegisterFormData();
  /*used to store entered password for validation*/
  late String _password = '';
  bool _userAlreadyExists = false;
  bool _invalidEmail = false;

  @override
  Widget build(BuildContext context) {
    final _slideUpState = Provider.of<SlideUpStateProvider>(context);
    final _authenticationProvider =
        Provider.of<AuthenticationProvider>(context);

    void errorValidation(dynamic onError) {
      if (onError.toString() ==
          "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
        _userAlreadyExists = true;
      } else if (onError.toString() ==
          "[firebase_auth/invalid-email] The email address is badly formatted.") {
        _invalidEmail = true;
      }
      widget._formKey.currentState?.validate();
      _userAlreadyExists = false;
      _invalidEmail = false;
    }

    void _saveForm() {
      /*validate the form*/
      final isValid = widget._formKey.currentState?.validate();
      if (isValid!) {
        /*save form at the new object authData*/
        widget._formKey.currentState?.save();
        /*use auth provider to complete registration and deal with any errors*/
        _authenticationProvider.registerEmailPassword(_registerData).then(
          (_) {
            /*if auth sucessfull then return to login screen*/
            _slideUpState.panelController.close();
          },
        ).catchError(
          (onError) {
            /*if login not sucessfull then show in validation*/
            errorValidation(onError);
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
                  style: Provider.of<FontSizeProvider>(context).headline1,
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
          RevampFormField(
            fieldTitle: "Email",
            fieldFocusNode: _emailFocusNode,
            nextFieldFocudNode: _passwordFocusNode,
            obscureText: false,
            onSaved: (value) => {_registerData.setEmail(value), 11},
            validator: (value) {
              if (_userAlreadyExists) {
                return "Sorry this email is already in use";
              } else if (_invalidEmail) {
                return "Sorry this email address is badly formatted";
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
              _registerData.setPassword(value),
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
            onSaved: (value) => {
              _registerData.setIsHairArtist(widget._isHairArtist),
            },
            validator: (value) {
              if (_password != value) {
                return "Passwords do not match";
              }
              return null;
            },
          ),
          SmallButton(
            child: Text(
              "Register",
              style: Provider.of<FontSizeProvider>(context).button,
            ),
            backgroundColor: Theme.of(context).primaryColor, 
            onPressed: () => {
              FocusScope.of(context).unfocus(), 
              _saveForm(),
            },
            buttonWidth: 110,
          ),
        ],
      ),
    );
  }
}
