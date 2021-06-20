import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/text_size_provider.dart';

class HProfRefForm extends StatefulWidget {
  static final _formKey = GlobalKey<FormState>();

  @override
  _HProfRefFormState createState() => _HProfRefFormState();
}

class _HProfRefFormState extends State<HProfRefForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Form(
        key: HProfRefForm._formKey,
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width / 15),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Text(
                    "Sign Up",
                    style: Provider.of<FontSize>(context).headline1,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 15),
                child: TextFormField(
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Repeat Password',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (HProfRefForm._formKey.currentState!.validate()) {
// If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
