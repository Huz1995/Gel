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
    var response = await http.get(
      Uri.parse("http://localhost:3000/api/hairArtistProfile/" +
          auth.loggedInUser.uid),
    );
    var jsonResponse = convert.jsonDecode(response.body);
    _userProfile = new HairArtistUserProfile(
      jsonResponse['uid'],
      jsonResponse['email'],
      auth.idToken,
      auth.isHairArtist,
      (jsonResponse['photoUrls'] as List).cast<String>(),
    );
    notifyListeners();
  }

  void saveNewImage(File file) async {
    print("df");
    final ref = FirebaseStorage.instance
        .ref()
        .child(_userProfile.email)
        .child("photo" + _userProfile.photoUrls.length.toString());
    await ref.putFile(file).whenComplete(
      () async {
        var photoUrl = await ref.getDownloadURL();
        _userProfile.addPhotoUrl(photoUrl);
        notifyListeners();
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
