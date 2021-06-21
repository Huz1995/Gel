import 'package:flutter/material.dart';
import 'package:gel/providers/slideup_frontpage_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/widgets/frontpage/small_button.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
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
              child: Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width / 15),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Text(
                          "Login",
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
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
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
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
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
              ))),
    );
  }
}
