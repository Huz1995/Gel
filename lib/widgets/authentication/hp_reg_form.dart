import 'package:flutter/material.dart';
import 'package:gel/providers/slideup_frontpage_provider.dart';
import 'package:provider/provider.dart';

import '../../providers/text_size_provider.dart';

class HProfRefForm extends StatefulWidget {
  @override
  _HProfRefFormState createState() => _HProfRefFormState();
}

class _HProfRefFormState extends State<HProfRefForm> {
  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _slideUpState = Provider.of<SlideUpState>(context);

    /*detectes if the slide up panel is not active so deletes the form
    data and focusnode*/
    if (!_slideUpState.isSlideUpPanelActive) {
      _formKey.currentState?.reset();
      FocusScope.of(context).unfocus();
    }

    return Container(
      child: Center(
          child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width / 15),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Text(
                    "Sign Up \nAs Hair Professional",
                    style: Provider.of<FontSize>(context).headline1,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 15),
                child: TextFormField(
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
                  if (_formKey.currentState!.validate()) {
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
