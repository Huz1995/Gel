import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/text_size_provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:gel/providers/slideup_frontpage_provider.dart';
import 'package:gel/widgets/frontpage/sliding_up_panel.dart';

class FrontPage extends StatelessWidget {
  final PanelController _panelController = new PanelController();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FontSizeProvider(context),
        ),
        ChangeNotifierProvider(
          create: (_) => SlideUpStateProvider(_panelController),
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.4), BlendMode.darken),
              image: AssetImage("assets/images/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SlidingUpPanelFrontPage(
              panelController: _panelController,
            ),
          ),
        ),
      ),
    );
  }
}
