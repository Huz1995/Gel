import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gel/models/hair_artist_user_profile.dart';
import 'package:gel/providers/custom_dialogs.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:gel/providers/ui_service.dart';
import 'package:image_picker/image_picker.dart';

class HairArtistProfilePicIcon extends StatefulWidget {
  HairArtistProfilePicIcon({
    Key? key,
    required double phoneWidth,
    required bool isForDisplay,
    HairArtistProfileProvider? hairArtistProfileProvider,
    required HairArtistUserProfile hairArtistUserProfile,
  })  : _phoneWidth = phoneWidth,
        _hairArtistProfileProvider = hairArtistProfileProvider,
        _isForDisplay = isForDisplay,
        _hairArtistUserProfile = hairArtistUserProfile,
        super(key: key);

  final double _phoneWidth;
  final HairArtistProfileProvider? _hairArtistProfileProvider;
  final bool _isForDisplay;
  final HairArtistUserProfile _hairArtistUserProfile;

  @override
  _HairArtistProfilePicIconState createState() =>
      _HairArtistProfilePicIconState();
}

class _HairArtistProfilePicIconState extends State<HairArtistProfilePicIcon> {
  /*init image picker so user can pic image from phones gallery*/
  final _imagePicker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    final bool doesHaveProfilePhoto =
        (widget._hairArtistUserProfile.profilePhotoUrl != null);
    bool _pickedCamera = false;

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
        widget._hairArtistProfileProvider!.addProfilePicture(File(image.path));
      }
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Stack(
          children: [
            UIService.getProfilePicIcon(doesHaveProfilePhoto, context,
                widget._hairArtistUserProfile.profilePhotoUrl),
            !widget._isForDisplay
                ? Positioned(
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
                                [
                                  Text("Please select one of the options below")
                                ],
                                Text("Cancel"),
                                () {
                                  Navigator.of(context).pop();
                                },
                                Text("Remove"),
                                () {
                                  widget._hairArtistProfileProvider!
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
                                [
                                  Text("Please select one of the options below")
                                ],
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
                  )
                : Text(""),
          ],
        ),
      ),
    );
  }
}
