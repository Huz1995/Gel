import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gel/providers/slideup_frontpage_provider.dart';
import 'package:gel/widgets/authentication/register_form_fields.dart';

class HProfRegForm extends StatefulWidget {
  @override
  _HProfRegFormState createState() => _HProfRegFormState();
}

class _HProfRegFormState extends State<HProfRegForm> {
  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _slideUpState = Provider.of<SlideUpState>(context);

    /*detectes if the slide up panel is not active so deletes the form
    data and focusnode*/
    if (!_slideUpState.isSlideUpPanelOpen) {
      _formKey.currentState?.reset();
      FocusScope.of(context).unfocus();
    }

    return Container(
      child: Center(
          child: Form(
        key: _formKey,
        child: RegisterFormFields(
          formKey: _formKey,
          formTitle: "Sign Up \nAs Hair Professional",
          isHairArtist: true,
        ),
      )),
    );
  }
}