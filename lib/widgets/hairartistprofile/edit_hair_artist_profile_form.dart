import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:provider/provider.dart';

class EditHairArtistProfileForm extends StatelessWidget {
  static final _basicInfoFormKey = GlobalKey<FormState>();
  static final _workInfoFormkey = GlobalKey<FormState>();
  final FontSizeProvider _fontSizeProvider;
  final HairArtistProfileProvider _hairArtistProvider;

  EditHairArtistProfileForm(this._fontSizeProvider, this._hairArtistProvider);

  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthenticationProvider>(context);
    print("built");

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
          FloatingActionButton(
            heroTag: "save",
            splashColor: Colors.white,
            backgroundColor: Colors.white,
            elevation: 0,
            focusElevation: 0,
            onPressed: () {
              _basicInfoFormKey.currentState!.save();
              _workInfoFormkey.currentState!.save();
              _hairArtistProvider.setAboutDetails();
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
          style: _fontSizeProvider.headline3,
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
                height: 30,
              ),
              Container(
                padding: EdgeInsets.only(left: 30),
                child: Text(
                  "About",
                  style: _fontSizeProvider.headline3,
                ),
              ),
              Form(
                key: _basicInfoFormKey,
                child: Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width / 15),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: TextFormField(
                          initialValue:
                              _hairArtistProvider.hairArtistProfile.about!.name,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          onSaved: (value) => {
                            _hairArtistProvider.hairArtistProfile.about!.name =
                                value!,
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
                          initialValue: _hairArtistProvider
                              .hairArtistProfile.about!.contactNumber,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          onSaved: (value) => {
                            _hairArtistProvider.hairArtistProfile.about!
                                .contactNumber = value!,
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Contact Number',
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
                          initialValue: _hairArtistProvider
                              .hairArtistProfile.about!.instaUrl
                              .split("/")
                              .last,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          onSaved: (value) => {
                            _hairArtistProvider
                                    .hairArtistProfile.about!.instaUrl =
                                "https://www.instagram.com/" + value!,
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
                          initialValue: _hairArtistProvider
                              .hairArtistProfile.about!.description,
                          maxLines: 10,
                          keyboardType: TextInputType.multiline,
                          onSaved: (value) => {
                            _hairArtistProvider
                                .hairArtistProfile.about!.description = value!,
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
                          initialValue: _hairArtistProvider
                              .hairArtistProfile.about!.chatiness,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          onSaved: (value) => {
                            _hairArtistProvider
                                .hairArtistProfile.about!.chatiness = value!,
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
                  style: _fontSizeProvider.headline3,
                ),
              ),
              Form(
                key: _workInfoFormkey,
                child: Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width / 15),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: TextFormField(
                          initialValue: _hairArtistProvider
                              .hairArtistProfile.about!.workingArrangement,
                          maxLines: 10,
                          keyboardType: TextInputType.multiline,
                          onSaved: (value) => {
                            _hairArtistProvider.hairArtistProfile.about!
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
                          initialValue: _hairArtistProvider
                              .hairArtistProfile.about!.previousWorkExperience,
                          maxLines: 10,
                          keyboardType: TextInputType.multiline,
                          onSaved: (value) => {
                            _hairArtistProvider.hairArtistProfile.about!
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
                          initialValue: _hairArtistProvider
                              .hairArtistProfile.about!.hairTypes,
                          maxLines: 10,
                          keyboardType: TextInputType.multiline,
                          onSaved: (value) => {
                            _hairArtistProvider
                                .hairArtistProfile.about!.hairTypes = value!,
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
                          initialValue: _hairArtistProvider
                              .hairArtistProfile.about!.shortHairServCost,
                          maxLines: 10,
                          keyboardType: TextInputType.multiline,
                          onSaved: (value) => {
                            _hairArtistProvider.hairArtistProfile.about!
                                .shortHairServCost = value!,
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'List short hair services with price',
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
                          initialValue: _hairArtistProvider
                              .hairArtistProfile.about!.longHairServCost,
                          maxLines: 10,
                          keyboardType: TextInputType.multiline,
                          onSaved: (value) => {
                            _hairArtistProvider.hairArtistProfile.about!
                                .longHairServCost = value!,
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'List long hair services with price',
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
