import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gel/providers/custom_dialogs.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class GalleryPicker extends StatefulWidget {
  GalleryPicker({Key? key}) : super(key: key);
  /*init image picker so user can pic image from phones gallery*/
  @override
  _GalleryPickerState createState() => _GalleryPickerState();
}

class _GalleryPickerState extends State<GalleryPicker> {
  bool _pickedCamera = false;
  final _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final _hairArtistProvider = Provider.of<HairArtistProfileProvider>(context);

    void _pickImage() async {
      PickedFile? image;

      if (_pickedCamera) {
        image = await _imagePicker.getImage(
          source: ImageSource.camera,
          imageQuality: 5,
        );
      } else {
        image = await _imagePicker.getImage(
          source: ImageSource.gallery,
          imageQuality: 5,
        );
      }
      if (image != null) {
        /*send this file to hair artist profile provider to send in fb storare and url in db*/
        _hairArtistProvider.saveNewImage(File(image.path));
      }
    }

    // Future<void> _loadAssets() async {
    //   List<Asset> resultList = <Asset>[];
    //   String error = 'No Error Detected';
    //   final tempDirectory = await Directory.systemTemp.create();
    //   File imageFile;

    //   try {
    //     resultList = await MultiImagePicker.pickImages(
    //       maxImages: 1,
    //       enableCamera: true,
    //       cupertinoOptions: CupertinoOptions(
    //         takePhotoIcon: "chat",
    //         doneButtonTitle: "Select",
    //       ),
    //       materialOptions: MaterialOptions(
    //         actionBarColor: "#abcdef",
    //         actionBarTitle: "Example App",
    //         allViewTitle: "All Photos",
    //         useDetailsView: false,
    //         selectCircleStrokeColor: "#000000",
    //       ),
    //     );
    //   } on Exception catch (e) {
    //     error = e.toString();
    //     print(error);
    //   }
    //   final data = await resultList[0].getByteData();
    //   imageFile = await File('${tempDirectory.path}/img').writeAsBytes(
    //       data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    //   _hairArtistProvider.saveNewImage(imageFile);
    // }

    return TextButton(
      child: Icon(
        MaterialIcons.add_a_photo,
        color: Colors.black,
        size: 30,
      ),
      onPressed: () {
        CustomDialogs.showMyDialogThreeButtons(
          context,
          Text("Add Photo"),
          [
            Text(
                "Would you like to select an image from your camera or gallery?")
          ],
          Text("Cancel"),
          () {
            Navigator.of(context).pop();
          },
          Text("Camera"),
          () {
            Navigator.of(context).pop();
            setState(
              () {
                _pickedCamera = true;
              },
            );
            _pickImage();
          },
          Text("Gallery"),
          () {
            Navigator.of(context).pop();
            setState(
              () {
                _pickedCamera = false;
              },
            );
            _pickImage();
          },
        );
      },
    );
  }
}
