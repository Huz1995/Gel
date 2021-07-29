import 'package:flutter/material.dart';
import 'package:gel/models/login_auth_model.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/widgets/general/long_button.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({
    Key? key,
    required AuthenticationProvider authenticationProvider,
  })  : _authenticationProvider = authenticationProvider,
        super(key: key);

  final AuthenticationProvider _authenticationProvider;
  static final _formKey = GlobalKey<FormState>();
  final _loginData = LoginFormData();

  @override
  Widget build(BuildContext context) {
    final FontSizeProvider _fontSizeProvider =
        Provider.of<FontSizeProvider>(context);
    late String _email;
    late String _validationMsg;

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
            child: Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width / 15),
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * 0.02),
                        child: Text(
                          "Reset Password",
                          style: _fontSizeProvider.headline1,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: TextFormField(
                      autocorrect: false,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onSaved: (value) => {
                        _email = value!,
                        print(_email),
                      },
                      validator: (value) {
                        return _validationMsg;
                      },
                      decoration: InputDecoration(
                        labelText: 'Email',
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Enter your email and we will send a link \n       for you to reset your password",
                          style: _fontSizeProvider.bodyText4,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  LongButton(
                      backgroundColor: Theme.of(context).primaryColor,
                      onPressed: () async {
                        _formKey.currentState!.save();
                        try {
                          await _authenticationProvider.forgotPassword(_email);
                          Navigator.of(context).pop();
                        } catch (e) {
                          _validationMsg = e.toString().split("] ")[1];
                          _formKey.currentState!.validate();
                        }
                      },
                      buttonName: "Get the Link"),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
