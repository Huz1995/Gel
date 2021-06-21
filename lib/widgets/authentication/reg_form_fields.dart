import 'package:flutter/material.dart';
import 'package:gel/widgets/frontpage/small_button.dart';
import 'package:provider/provider.dart';

import '../../providers/text_size_provider.dart';

class RegisterFormFields extends StatelessWidget {
  const RegisterFormFields({
    Key? key,
    required GlobalKey<FormState> formKey,
    required String formTitle,
  })  : _formKey = formKey,
        _formTitle = formTitle,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final String _formTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width / 15),
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Text(
                _formTitle,
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
                labelText: 'Username',
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
          SmallButton(
            buttonTitle: "Submit",
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () => print("submit"),
          ),
        ],
      ),
    );
  }
}
