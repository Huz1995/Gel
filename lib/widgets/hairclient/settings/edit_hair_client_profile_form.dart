import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/custom_dialogs.dart';
import 'package:gel/providers/hair_client_profile_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/providers/ui_service.dart';
import 'package:gel/widgets/general/small_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditHairClientProfileForm extends StatefulWidget {
  static final _formKey = GlobalKey<FormState>();
  final FontSizeProvider _fontSizeProvider;
  final HairClientProfileProvider _hairClientProfileProvider;

  EditHairClientProfileForm(
    this._fontSizeProvider,
    this._hairClientProfileProvider,
  );

  @override
  _EditHairClientProfileFormState createState() =>
      _EditHairClientProfileFormState();
}

class _EditHairClientProfileFormState extends State<EditHairClientProfileForm> {
  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthenticationProvider>(context);
    final _imagePicker = ImagePicker();
    bool _pickedCamera = false;
    bool doesHaveProfilePhoto =
        (widget._hairClientProfileProvider.hairClientProfile.profilePhotoUrl !=
            null);

    /*to ensure when auto logout occurs then we remove this widget the tree*/
    if (!_authProvider.isLoggedIn) {
      Timer(
        Duration(seconds: 1),
        () {
          Navigator.of(context).pop();
        },
      );
    }

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
      Navigator.of(context).pop();

      if (image != null) {
        /*send this file to hair artist profile provider to send in fb storare and url in db*/
        widget._hairClientProfileProvider.addProfilePicture(File(image.path));
      }
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              EditHairClientProfileForm._formKey.currentState!.save();
              widget._hairClientProfileProvider.setName();
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.save_outlined,
              color: Colors.black,
              size: 30,
            ),
          )
        ],
        backgroundColor: Colors.white, //change your color here
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        // backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Edit Profile",
          style: widget._fontSizeProvider.headline3,
        ),
      ),
      /*means user taps outside the gesture dector they remove the autofocus*/
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Center(
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: <Widget>[
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UIService.getProfilePicIcon(
                          hasProfilePic: doesHaveProfilePhoto,
                          context: context,
                          url: widget._hairClientProfileProvider
                              .hairClientProfile.profilePhotoUrl),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  SmallButton(
                    backgroundColor: Theme.of(context).accentColor,
                    child: Text("Change Profile Picture"),
                    buttonWidth: 250,
                    onPressed: () => doesHaveProfilePhoto
                        ? CustomDialogs.showMyDialogThreeButtons(
                            context: context,
                            title: Text("Update Profile Picture"),
                            body: [
                              Text("Please select one of the options below")
                            ],
                            buttonOnechild: Text("Cancel"),
                            buttonOneOnPressed: () {
                              Timer(
                                Duration(seconds: 1),
                                () => Navigator.of(context).pop(),
                              );
                            },
                            buttonTwochild: Text("Remove"),
                            buttonTwoOnPressed: () {
                              widget._hairClientProfileProvider
                                  .removeProfilePicture();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            buttonThreechild: Text("Replace"),
                            buttonThreeOnPressed: () {
                              Navigator.of(context).pop();
                              CustomDialogs.showMyDialogTwoButtons(
                                context: context,
                                title: Text("Replace"),
                                body: [Text("Please choose Camera or Gallery")],
                                buttonOnechild: Text("Camera"),
                                buttonOneOnPressed: () {
                                  Navigator.of(context).pop();
                                  setState(
                                    () {
                                      _pickedCamera = true;
                                    },
                                  );
                                },
                                buttonTwochild: Text("Gallery"),
                                buttonTwoOnPressed: () {
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
                            context: context,
                            title: Text("Update Profile Picture"),
                            body: [
                              Text("Please select one of the options below")
                            ],
                            buttonOnechild: Text("Cancel"),
                            buttonOneOnPressed: () {
                              Navigator.of(context).pop();
                            },
                            buttonTwochild: Text("Add"),
                            buttonTwoOnPressed: () {
                              Navigator.of(context).pop();
                              CustomDialogs.showMyDialogTwoButtons(
                                context: context,
                                title: Text("Add"),
                                body: [Text("Please choose Camera or Gallery")],
                                buttonOnechild: Text("Camera"),
                                buttonOneOnPressed: () {
                                  Navigator.of(context).pop();
                                  setState(
                                    () {
                                      _pickedCamera = true;
                                    },
                                  );
                                },
                                buttonTwochild: Text("Gallery"),
                                buttonTwoOnPressed: () {
                                  Navigator.of(context).pop();
                                  setState(
                                    () {
                                      _pickedCamera = false;
                                    },
                                  );
                                },
                              ).then((_) => _pickProfileImage());
                            },
                          ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                ],
              ),
              Form(
                key: EditHairClientProfileForm._formKey,
                child: Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width / 15),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: TextFormField(
                          initialValue: widget._hairClientProfileProvider
                              .hairClientProfile.name,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          onSaved: (value) => {
                            if (value == "")
                              {
                                widget._hairClientProfileProvider
                                    .hairClientProfile
                                    .setName("@" +
                                        widget._hairClientProfileProvider
                                            .hairClientProfile.email
                                            .split("@")[0]),
                              }
                            else
                              {
                                widget._hairClientProfileProvider
                                    .hairClientProfile
                                    .setName(value!),
                              }
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Name',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
