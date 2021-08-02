import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gel/providers/custom_dialogs.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

class ProfilePicIcon extends StatefulWidget {
  ProfilePicIcon({
    Key? key,
    required double phoneWidth,
    required HairArtistProfileProvider hairArtistProfileProvider,
  })  : _phoneWidth = phoneWidth,
        _hairArtistProfileProvider = hairArtistProfileProvider,
        super(key: key);

  final double _phoneWidth;

  final HairArtistProfileProvider _hairArtistProfileProvider;

  @override
  _ProfilePicIconState createState() => _ProfilePicIconState();
}

class _ProfilePicIconState extends State<ProfilePicIcon> {
  /*init image picker so user can pic image from phones gallery*/
  final _imagePicker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    final bool doesHaveProfilePhoto =
        (widget._hairArtistProfileProvider.hairArtistProfile.profilePhotoUrl !=
            null);
    bool _pickedCamera = false;

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
    //   _hairArtistProfileProvider.addProfilePicture(imageFile);
    // }

    //   var path =
    //       await FlutterAbsolutePath.getAbsolutePath(resultList[0].identifier);
    //   var file = File(path);
    //   _hairArtistProfileProvider.addProfilePicture(file);
    // }

    void _pickProfileImage() async {
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
        widget._hairArtistProfileProvider.addProfilePicture(File(image.path));
      }
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Stack(
          children: [
            doesHaveProfilePhoto
                ? CircleAvatar(
                    radius: widget._phoneWidth / 8,
                    backgroundColor: Theme.of(context).cardColor,
                    backgroundImage: NetworkImage(widget
                        ._hairArtistProfileProvider
                        .hairArtistProfile
                        .profilePhotoUrl!),
                  )
                : CircleAvatar(
                    radius: widget._phoneWidth / 8,
                    backgroundColor:
                        Theme.of(context).cardColor.withOpacity(0.3),
                  ),
            !doesHaveProfilePhoto
                ? Positioned(
                    left: widget._phoneWidth * 0.080,
                    bottom: widget._phoneWidth * 0.080,
                    //bottom: _phoneWidth / 4,
                    child: Icon(
                      Icons.person,
                      size: 40,
                    ),
                  )
                : Text(""),
            Positioned(
              left: widget._phoneWidth * 0.170,
              bottom: widget._phoneWidth * 0.1350,
              //bottom: _phoneWidth / 4,
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: 30),
                child: FloatingActionButton(
                  heroTag: "addPhoto",
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(
                    MaterialIcons.camera_alt,
                    size: 18,
                  ),
                  onPressed: () => doesHaveProfilePhoto
                      ? CustomDialogs.showMyDialogThreeButtons(
                          context,
                          Text("Update Profile Picture"),
                          [Text("Please select one of the options below")],
                          Text("Cancel"),
                          () {
                            Navigator.of(context).pop();
                          },
                          Text("Remove"),
                          () {
                            widget._hairArtistProfileProvider
                                .removeProfilePicture();
                            Navigator.of(context).pop();
                          },
                          Text("Replace"),
                          () {
                            Navigator.of(context).pop();
                            CustomDialogs.showMyDialogTwoButtons(
                              context,
                              Text("Replace"),
                              [Text("Please choose Camera or Gallery")],
                              Text("Camera"),
                              () {
                                Navigator.of(context).pop();
                                setState(
                                  () {
                                    _pickedCamera = true;
                                  },
                                );
                              },
                              Text("Gallery"),
                              () {
                                Navigator.of(context).pop();
                                setState(
                                  () {
                                    _pickedCamera = false;
                                  },
                                );
                              },
                            ).then((_) => _pickProfileImage());
                            //_pickProfileImage();
                          },
                        )
                      : CustomDialogs.showMyDialogTwoButtons(
                          context,
                          Text("Update Profile Picture"),
                          [Text("Please select one of the options below")],
                          Text("Cancel"),
                          () {
                            Navigator.of(context).pop();
                          },
                          Text("Add"),
                          () {
                            Navigator.of(context).pop();
                            CustomDialogs.showMyDialogTwoButtons(
                              context,
                              Text("Add"),
                              [Text("Please choose Camera or Gallery")],
                              Text("Camera"),
                              () {
                                Navigator.of(context).pop();
                                setState(
                                  () {
                                    _pickedCamera = true;
                                  },
                                );
                              },
                              Text("Gallery"),
                              () {
                                Navigator.of(context).pop();
                                setState(
                                  () {
                                    _pickedCamera = false;
                                  },
                                );
                              },
                            ).then((_) => _pickProfileImage());
                          },
                          //_pickProfileImage();,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
