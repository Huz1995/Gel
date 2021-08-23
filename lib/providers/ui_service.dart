import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UIService {
  /*function that created image from the url*/
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

  /*function that makes marker from url where image is stored*/
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

  /*Function that creates a profile icon from url, if doesnt have url then will
  return a defaul profile icon*/
  static Widget getProfilePicIcon(
      {bool? hasProfilePic,
      BuildContext? context,
      String? url,
      double? radius}) {
    if (hasProfilePic!) {
      return CircleAvatar(
        radius:
            (radius == null) ? MediaQuery.of(context!).size.width / 8 : radius,
        backgroundColor: Theme.of(context!).cardColor,
        backgroundImage: NetworkImage(url!),
      );
    }
    return Stack(
      children: [
        CircleAvatar(
          radius: (radius == null)
              ? MediaQuery.of(context!).size.width / 8
              : radius,
          backgroundColor: Theme.of(context!).cardColor.withOpacity(0.3),
        ),
        // Positioned(
        //   left: MediaQuery.of(context).size.width * 0.075,
        //   bottom: MediaQuery.of(context).size.width * 0.075,
        //   //bottom: _phoneWidth / 4,
        //   child: Icon(
        //     Icons.person,
        //     size: 40,
        //     color: Colors.black,
        //   ),
        // )
      ],
    );
  }

  static PreferredSizeWidget? generalAppBar(
      BuildContext context, String title, Widget? flexibleSpace) {
    return AppBar(
      flexibleSpace: flexibleSpace,
      backgroundColor: Colors.white, //change your color here
      iconTheme: IconThemeData(
        color: Colors.black, //change your color here
      ),
      // backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        title,
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  /*ui function that returns a widget when the hair artists has no reviews or photos*/
  static Widget noElementsToShowMessage(
    BuildContext context,
    bool isForDisplay,
    Icon icon,
    String titleClient,
    String titleArtist,
    String blurbArtist,
  ) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: MediaQuery.of(context).size.width / 7,
              backgroundColor: Theme.of(context).cardColor.withOpacity(0.1),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width * 0.078,
              bottom: MediaQuery.of(context).size.width * 0.078,
              //bottom: _phoneWidth / 4,
              child: icon,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Text(
            !isForDisplay ? titleArtist : titleClient,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.06,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        !isForDisplay
            ? Padding(
                padding: const EdgeInsets.fromLTRB(50, 10, 50, 0),
                child: Text(
                  blurbArtist,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    color: Colors.black,
                  ),
                ),
              )
            : Text(""),
      ],
    );
  }
}
