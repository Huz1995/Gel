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

    return TextButton(
      child: Icon(
        MaterialIcons.add_a_photo,
        color: Colors.black,
        size: 30,
      ),
      onPressed: () {
        CustomDialogs.showMyDialogThreeButtons(
          context: context,
          title: Text("Add Photo"),
          body: [
            Text(
                "Would you like to select an image from your camera or gallery?")
          ],
          buttonOnechild: Text("Cancel"),
          buttonOneOnPressed: () {
            Navigator.of(context).pop();
          },
          buttonTwochild: Text("Camera"),
          buttonTwoOnPressed: () {
            Navigator.of(context).pop();
            setState(
              () {
                _pickedCamera = true;
              },
            );
            _pickImage();
          },
          buttonThreechild: Text("Gallery"),
          buttonThreeOnPressed: () {
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
