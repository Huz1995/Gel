import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

class ProfilePicIcon extends StatelessWidget {
  ProfilePicIcon({
    Key? key,
    required double phoneWidth,
    required ImagePicker imagePicker,
    required HairArtistProfileProvider hairArtistProfileProvider,
  })  : _phoneWidth = phoneWidth,
        _imagePicker = imagePicker,
        _hairArtistProfileProvider = hairArtistProfileProvider,
        super(key: key);

  final double _phoneWidth;
  final ImagePicker _imagePicker;
  final HairArtistProfileProvider _hairArtistProfileProvider;

  @override
  Widget build(BuildContext context) {
    final bool doesHaveProfilePhoto =
        (_hairArtistProfileProvider.hairArtistProfile.profilePhotoUrl != null);

    Future<void> loadAssets() async {
      List<Asset> resultList = <Asset>[];
      String error = 'No Error Detected';

      try {
        resultList = await MultiImagePicker.pickImages(
          maxImages: 1,
          enableCamera: true,
          cupertinoOptions: CupertinoOptions(
            takePhotoIcon: "chat",
            doneButtonTitle: "Select",
          ),
          materialOptions: MaterialOptions(
            actionBarColor: "#abcdef",
            actionBarTitle: "Example App",
            allViewTitle: "All Photos",
            useDetailsView: false,
            selectCircleStrokeColor: "#000000",
          ),
        );
      } on Exception catch (e) {
        error = e.toString();
        print(error);
      }

      var path =
          await FlutterAbsolutePath.getAbsolutePath(resultList[0].identifier);
      var file = File(path);
      _hairArtistProfileProvider.addProfilePicture(file);
      print(path);
    }

    // void _pickProfileImage() async {
    //   final PickedFile? image = await _imagePicker.getImage(
    //     source: ImageSource.gallery,
    //     imageQuality: 5,
    //   );
    //   if (image != null) {
    //     /*send this file to hair artist profile provider to send in fb storare and url in db*/
    //     _hairArtistProfileProvider.addProfilePicture(File(image.path));
    //   }
    // }

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Stack(
          children: [
            doesHaveProfilePhoto
                ? CircleAvatar(
                    radius: _phoneWidth / 8,
                    backgroundColor: Theme.of(context).cardColor,
                    backgroundImage: NetworkImage(_hairArtistProfileProvider
                        .hairArtistProfile.profilePhotoUrl!),
                  )
                : CircleAvatar(
                    radius: _phoneWidth / 8,
                    backgroundColor:
                        Theme.of(context).cardColor.withOpacity(0.3),
                  ),
            !doesHaveProfilePhoto
                ? Positioned(
                    left: _phoneWidth * 0.080,
                    bottom: _phoneWidth * 0.080,
                    //bottom: _phoneWidth / 4,
                    child: Icon(
                      Icons.person,
                      size: 40,
                    ),
                  )
                : Text(""),
            Positioned(
              left: _phoneWidth * 0.170,
              bottom: _phoneWidth * 0.1350,
              //bottom: _phoneWidth / 4,
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: 30),
                child: FloatingActionButton(
                  heroTag: "addPhoto",
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.7),
                  child: Icon(
                    doesHaveProfilePhoto ? MaterialIcons.swap_vert : Icons.add,
                  ),
                  onPressed: loadAssets,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
