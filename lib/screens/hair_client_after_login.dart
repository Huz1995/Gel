import 'package:flutter/material.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/widgets/small_button.dart';
import 'package:provider/provider.dart';

class ClientDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthenticationProvider>(context);

    return Scaffold(
      body: Center(
        child: SmallButton(
          backgroundColor: Colors.blue,
          child: Text(
            "logout - hc",
          ),
          onPressed: () => {
            _authProvider.logUserOut(),
          },
        ),
      ),
    );
  }
}
