import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gel/models/hair_artist_user_profile.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HairArtistProfileProvider extends ChangeNotifier {
  HairArtistUserProfile _userProfile =
      HairArtistUserProfile("", "", false, [], null, null);
  late String _idToken;

  HairArtistProfileProvider(AuthenticationProvider auth) {
    /* when we initate the hair artist profile then get the user data from the back end*/
    _idToken = auth.idToken;
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
      headers: {
        HttpHeaders.authorizationHeader: _idToken,
      },
    );
    /*convert the response from string to JSON*/
    var jsonResponse = convert.jsonDecode(response.body);
    /*create new Hair artist about info object*/
    HairArtistAboutInfo _about = new HairArtistAboutInfo(
      jsonResponse['about']['name'],
      jsonResponse['about']['contactNumber'],
      jsonResponse['about']['instaUrl'],
      jsonResponse['about']['description'],
      jsonResponse['about']['chatiness'],
      jsonResponse['about']['workingArrangement'],
      jsonResponse['about']['previousWorkExperience'],
      jsonResponse['about']['hairTypes'],
      jsonResponse['about']['shortHairServCost'],
      jsonResponse['about']['longHairServCost'],
    );
    /*create new HairArtistObject object and set the attributes in contructor to build object*/
    _userProfile = new HairArtistUserProfile(
      jsonResponse['uid'],
      jsonResponse['email'],
      auth.isHairArtist,
      (jsonResponse['photoUrls'] as List).cast<String>(),
      jsonResponse['profilePhotoUrl'],
      _about,
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
    /*store the file in firbase storage and call on complete callback*/
    await ref.putFile(file).whenComplete(
      () async {
        /*when complete get the image url from firebase storeage*/
        var photoUrl = await ref.getDownloadURL();
        /*add it to userprofile object so widgets can render image*/
        _userProfile.addPhotoUrl(photoUrl);
        notifyListeners();
        /*send the url to backend and store in mongodb for persistance*/
        await http.put(
          Uri.parse("http://localhost:3000/api/hairArtistProfile/photos"),
          body: {
            'uid': _userProfile.uid,
            'photoUrl': photoUrl,
          },
          headers: {
            HttpHeaders.authorizationHeader: _idToken,
          },
        );
      },
    );
  }

  void addProfilePicture(File file) async {
    /*create a storeage ref from firebase*/
    final ref = FirebaseStorage.instance
        .ref()
        .child(_userProfile.email)
        .child("profile picture");
    /*store the file in firbase storage and call on complete callback*/
    await ref.putFile(file).whenComplete(
      () async {
        /*when complete get the image url from firebase storeage*/
        var photoUrl = await ref.getDownloadURL();
        /*add it to userprofile object so widgets can render image*/
        _userProfile.addProfilePictureUrl(photoUrl);
        notifyListeners();
        /*send the url to backend and store in mongodb for persistance*/
        await http.put(
          Uri.parse(
              "http://localhost:3000/api/hairArtistProfile/profilepicture"),
          body: {
            'uid': _userProfile.uid,
            'photoUrl': photoUrl,
          },
          headers: {
            HttpHeaders.authorizationHeader: _idToken,
          },
        );
      },
    );
  }

  Future<void> setAboutDetails() async {
    await http.put(
      Uri.parse("http://localhost:3000/api/hairArtistProfile/about/" +
          _userProfile.uid +
          "/"),
      body: _userProfile.about!.toObject(),
      headers: {
        HttpHeaders.authorizationHeader: _idToken,
      },
    );
    notifyListeners();
  }

  Future<void> deletePhotoUrl(String url) async {
    /*create a firebase reference from url*/
    final ref = FirebaseStorage.instance.refFromURL(url);
    await ref.delete().whenComplete(
      () async {
        _userProfile.deletePhotoUrl(url);
        http.delete(
          Uri.parse("http://localhost:3000/api/hairArtistProfile/photos"),
          body: {
            'uid': _userProfile.uid,
            'photoUrl': url,
          },
          headers: {
            HttpHeaders.authorizationHeader: _idToken,
          },
        );
      },
    );
    notifyListeners();
  }
}
