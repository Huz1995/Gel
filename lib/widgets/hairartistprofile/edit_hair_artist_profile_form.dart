import 'package:flutter/material.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:provider/provider.dart';

class EditHairArtistProfileForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("df");
    final _fontSizeProvider = Provider.of<FontSizeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        // backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Edit",
          style: _fontSizeProvider.headline2,
        ),
      ),
      body: Center(
        child: Text("Edit"),
      ),
    );
  }
}
