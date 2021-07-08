import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gel/models/hair_artist_user_profile.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HairArtistProfileProvider extends ChangeNotifier {
  HairArtistUserProfile _userProfile =
      HairArtistUserProfile("", "", "", false, []);

  HairArtistProfileProvider(AuthenticationProvider auth) {
    getUserDataFromBackend(auth);
  }

  HairArtistUserProfile get hairArtistProfile {
    return _userProfile;
  }

  Future<void> getUserDataFromBackend(AuthenticationProvider auth) async {
    /*issue a get req to hairArtistProfile to get their information to display*/
    var response = await http.get(
      Uri.parse("http://localhost:3000/api/hairArtistProfile/" +
          auth.loggedInUser.uid),
    );
    /*convert the response from string to JSON*/
    var jsonResponse = convert.jsonDecode(response.body);
    /*create newe object and set the attributes in contructor to build object*/
    _userProfile = new HairArtistUserProfile(
      jsonResponse['uid'],
      jsonResponse['email'],
      auth.idToken,
      auth.isHairArtist,
      (jsonResponse['photoUrls'] as List).cast<String>(),
    );
    /*updates the profile object so wigets listen can use its data*/
    notifyListeners();
  }

  void saveNewImage(File file) async {
    /*create a storeage ref from firebase*/
    final ref = FirebaseStorage.instance
        .ref()
        .child(_userProfile.email)
        .child("mainPhotos")
        .child("picture" + _userProfile.photoUrls.length.toString());
    /*store the file*/
    await ref.putFile(file).whenComplete(
      () async {
        /*when complete get the url from firebase storeage*/
        var photoUrl = await ref.getDownloadURL();
        /*add it to userprofile object so widgets can render image*/
        _userProfile.addPhotoUrl(photoUrl);
        notifyListeners();
        /*send the url to backend and store in mongodb for persistance*/
        await http.put(
          Uri.parse("http://localhost:3000/api/hairArtistProfile/addphoto"),
          body: {
            'uid': _userProfile.uid,
            'photoUrl': photoUrl,
          },
        );
      },
    );
  }
}
