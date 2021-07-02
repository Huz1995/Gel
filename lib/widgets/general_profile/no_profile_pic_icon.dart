import 'package:flutter/material.dart';

class NoProfilePicIcon extends StatelessWidget {
  const NoProfilePicIcon({
    Key? key,
    required double phoneWidth,
  })  : _phoneWidth = phoneWidth,
        super(key: key);

  final double _phoneWidth;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: _phoneWidth / 10,
          backgroundColor: Theme.of(context).cardColor.withOpacity(0.3),
        ),
        Positioned(
          left: _phoneWidth * 0.060,
          bottom: _phoneWidth * 0.060,
          //bottom: _phoneWidth / 4,
          child: Icon(
            Icons.person,
            size: 35,
          ),
        ),
      ],
    );
  }
}
