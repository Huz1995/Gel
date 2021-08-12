import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UIService {
  static Future<ui.Image> getImageFromUrl(String url) async {
    Completer<ImageInfo> completer = Completer();
    var img = new NetworkImage(url);
    img
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info);
    }));
    ImageInfo imageInfo = await completer.future;
    return imageInfo.image;
  }

  static Future<BitmapDescriptor> getMarkerIcon(String url, Size size) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Radius radius = Radius.circular(size.width / 2);

    final Paint tagPaint = Paint()..color = Colors.blue;
    final double tagWidth = 40.0;

    final Paint shadowPaint = Paint()..color = Colors.blue.withAlpha(100);
    final double shadowWidth = 10.0;

    final Paint borderPaint = Paint()..color = Colors.white;
    final double borderWidth = 5.0;

    final double imageOffset = shadowWidth + borderWidth;

    // Add shadow circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, size.width, size.height),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        shadowPaint);

    // Add border circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(shadowWidth, shadowWidth,
              size.width - (shadowWidth * 2), size.height - (shadowWidth * 2)),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        borderPaint);

    // Oval for the image
    Rect oval = Rect.fromLTWH(imageOffset, imageOffset,
        size.width - (imageOffset * 2), size.height - (imageOffset * 2));

    // Add path for oval image
    canvas.clipPath(Path()..addOval(oval));

    // Add image
    ui.Image image = await UIService.getImageFromUrl(
        url); // Alternatively use your own method to get the image
    paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitWidth);

    // Convert canvas to image
    final ui.Image markerAsImage = await pictureRecorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());

    // Convert image to bytes
    final ByteData? byteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }

  static Widget getProfilePicIcon(
      bool hasProfilePic, BuildContext context, String? url) {
    if (hasProfilePic) {
      return CircleAvatar(
        radius: MediaQuery.of(context).size.width / 8,
        backgroundColor: Theme.of(context).cardColor,
        backgroundImage: NetworkImage(url!),
      );
    }
    return Stack(
      children: [
        CircleAvatar(
          radius: MediaQuery.of(context).size.width / 8,
          backgroundColor: Theme.of(context).cardColor.withOpacity(0.3),
        ),
        Positioned(
          left: MediaQuery.of(context).size.width * 0.075,
          bottom: MediaQuery.of(context).size.width * 0.075,
          //bottom: _phoneWidth / 4,
          child: Icon(
            Icons.person,
            size: 40,
          ),
        )
      ],
    );
  }
}