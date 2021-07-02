import 'dart:io';

import 'package:flutter/material.dart';

class Gallery extends StatelessWidget {
  const Gallery({
    Key? key,
    required List<File> pickedImages,
  })  : _pickedImages = pickedImages,
        super(key: key);

  final List<File> _pickedImages;
  @override
  Widget build(BuildContext context) {
    print(_pickedImages);
    return Container(
      child: Center(
        child: Text(
          "You have no pictures!, click camera icon to add pictures so people can see how amazing your hairfressing is",
        ),
      ),
    );
  }
}
