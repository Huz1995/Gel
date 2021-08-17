import 'package:flutter/material.dart';
import 'package:gel/providers/ui_service.dart';

class MessagesMainPage extends StatelessWidget {
  const MessagesMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIService.generalAppBar(context, "Messages"),
      body: Center(
        child: Text("Messages"),
      ),
    );
  }
}
