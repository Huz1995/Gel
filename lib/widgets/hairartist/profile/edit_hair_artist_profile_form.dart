import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

class EditHairArtistProfileForm extends StatefulWidget {
  static final _basicInfoFormKey = GlobalKey<FormState>();
  static final _workInfoFormkey = GlobalKey<FormState>();
  final FontSizeProvider _fontSizeProvider;
  final HairArtistProfileProvider _hairArtistProvider;

  EditHairArtistProfileForm(this._fontSizeProvider, this._hairArtistProvider);

  @override
  _EditHairArtistProfileFormState createState() =>
      _EditHairArtistProfileFormState();
}

class _EditHairArtistProfileFormState extends State<EditHairArtistProfileForm> {
  final TextEditingController controller = TextEditingController();
  PhoneNumber _number = PhoneNumber(isoCode: 'GB');

  @override
  void initState() {
    String phoneNumber =
        widget._hairArtistProvider.hairArtistProfile.about.contactNumber;
    String dialCode =
        widget._hairArtistProvider.hairArtistProfile.about.dialCode;
    String isoCode = widget._hairArtistProvider.hairArtistProfile.about.isoCode;
    if (dialCode != "" && phoneNumber != "") {
      PhoneNumber number = PhoneNumber(
          phoneNumber: phoneNumber, isoCode: isoCode, dialCode: dialCode);
      setState(() {
        _number = number;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthenticationProvider>(context);

    /*to ensure when au.to logout occurs then we remove this widget the tree*/
    if (!_authProvider.isLoggedIn) {
      Timer(
        Duration(seconds: 1),
        () {
          Navigator.of(context).pop();
        },
      );
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              EditHairArtistProfileForm._basicInfoFormKey.currentState!.save();
              EditHairArtistProfileForm._workInfoFormkey.currentState!.save();
              widget._hairArtistProvider.setAboutDetails();
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                padding: EdgeInsets.only(left: 30),
                child: Text(
                  "About",
                  style: widget._fontSizeProvider.headline3,
                ),
              ),
              Form(
                key: EditHairArtistProfileForm._basicInfoFormKey,
                child: Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width / 15),
                  child: Column(
                    children: <Widget>[
                      InternationalPhoneNumberInput(
                        onInputChanged: (PhoneNumber number) {},
                        onInputValidated: (bool value) {},
                        selectorConfig: SelectorConfig(
                          selectorType: PhoneInputSelectorType.DIALOG,
                        ),
                        ignoreBlank: true,
                        autoValidateMode: AutovalidateMode.always,
                        selectorTextStyle: TextStyle(color: Colors.black),
                        initialValue: _number,
                        textFieldController: controller,
                        formatInput: false,
                        hintText: _number.phoneNumber != null
                            ? _number.phoneNumber
                            : "Phone Number",
                        inputBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        onSaved: (PhoneNumber number) {
                          if (number.parseNumber() != "") {
                            widget._hairArtistProvider.hairArtistProfile.about
                                .contactNumber = number.parseNumber();
                            widget._hairArtistProvider.hairArtistProfile.about
                                .dialCode = number.dialCode!;
                            widget._hairArtistProvider.hairArtistProfile.about
                                .isoCode = number.isoCode!;
                          } else {
                            widget._hairArtistProvider.hairArtistProfile.about
                                .contactNumber = number.parseNumber();
                            widget._hairArtistProvider.hairArtistProfile.about
                                .dialCode = "";
                            widget._hairArtistProvider.hairArtistProfile.about
                                .isoCode = "";
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: TextFormField(
                          initialValue: widget
                              ._hairArtistProvider.hairArtistProfile.about.name,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          onSaved: (value) => {
                            if (value == "")
                              {
                                widget._hairArtistProvider.hairArtistProfile
                                        .about.name =
                                    "@" +
                                        widget._hairArtistProvider
                                            .hairArtistProfile.email
                                            .split("@")[0],
                              }
                            else
                              {
                                widget._hairArtistProvider.hairArtistProfile
                                    .about.name = value!,
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: TextFormField(
                          initialValue: widget._hairArtistProvider
                              .hairArtistProfile.about.instaUrl
                              .split("/")
                              .last,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          onSaved: (value) => {
                            if (value != "")
                              {
                                widget._hairArtistProvider.hairArtistProfile
                                        .about.instaUrl =
                                    "https://www.instagram.com/" + value!,
                              }
                            else
                              {
                                widget._hairArtistProvider.hairArtistProfile
                                    .about.instaUrl = value!,
                              }
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Instagram Username',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: TextFormField(
                          initialValue: widget._hairArtistProvider
                              .hairArtistProfile.about.description,
                          maxLines: 10,
                          keyboardType: TextInputType.multiline,
                          onSaved: (value) => {
                            widget._hairArtistProvider.hairArtistProfile.about
                                .description = value!,
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Description',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: TextFormField(
                          initialValue: widget._hairArtistProvider
                              .hairArtistProfile.about.chatiness,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          onSaved: (value) => {
                            widget._hairArtistProvider.hairArtistProfile.about
                                .chatiness = value!,
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText:
                                'Describe your chatiness when with client',
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
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.only(left: 30),
                child: Text(
                  "Work related stuff",
                  style: widget._fontSizeProvider.headline3,
                ),
              ),
              Form(
                key: EditHairArtistProfileForm._workInfoFormkey,
                child: Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width / 15),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: TextFormField(
                          initialValue: widget._hairArtistProvider
                              .hairArtistProfile.about.workingArrangement,
                          maxLines: 10,
                          keyboardType: TextInputType.multiline,
                          onSaved: (value) => {
                            widget._hairArtistProvider.hairArtistProfile.about
                                .workingArrangement = value!,
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText:
                                'Working arrangements eg can you travel to client',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: TextFormField(
                          initialValue: widget._hairArtistProvider
                              .hairArtistProfile.about.previousWorkExperience,
                          maxLines: 10,
                          keyboardType: TextInputType.multiline,
                          onSaved: (value) => {
                            widget._hairArtistProvider.hairArtistProfile.about
                                .previousWorkExperience = value!,
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText:
                                'List previous experience and prior workplaces',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: TextFormField(
                          initialValue: widget._hairArtistProvider
                              .hairArtistProfile.about.hairTypes,
                          maxLines: 10,
                          keyboardType: TextInputType.multiline,
                          onSaved: (value) => {
                            widget._hairArtistProvider.hairArtistProfile.about
                                .hairTypes = value!,
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText:
                                'List hair types you specialise in, eg wavy',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: TextFormField(
                          initialValue: widget._hairArtistProvider
                              .hairArtistProfile.about.hairServCost,
                          maxLines: 10,
                          keyboardType: TextInputType.multiline,
                          onSaved: (value) => {
                            widget._hairArtistProvider.hairArtistProfile.about
                                .hairServCost = value!,
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'List hair services with price',
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
