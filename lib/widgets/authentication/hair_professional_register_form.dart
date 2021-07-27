import 'package:flutter/material.dart';

import 'package:gel/widgets/authentication/register_form_fields.dart';

class HProfRegForm extends StatelessWidget {
  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.black,
        ),
      ),
      body: Container(
        child: Center(
          child: Form(
            key: _formKey,
            child: RegisterFormFields(
              formKey: _formKey,
              formTitle: "Register \nAs Hair Artist",
              isHairArtist: true,
            ),
          ),
        ),
      ),
    );
  }
}
