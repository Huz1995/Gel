import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gel/models/hair_artist_user_profile.dart';
import 'package:gel/models/hair_client_user_profile.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HairClientProfileProvider extends ChangeNotifier {
  HairClientUserProfile _userProfile =
      HairClientUserProfile("", "", false, "", "", []);
  late String _loggedInUserIdToken;

  HairClientProfileProvider(AuthenticationProvider auth) {
    /* when we initate the hair artist profile then get the user data from the back end*/
    _loggedInUserIdToken = auth.idToken;
    getUserDataFromBackend(auth);
  }

  HairClientUserProfile get hairClientProfile {
    return _userProfile;
  }

  Future<void> getUserDataFromBackend(AuthenticationProvider auth) async {
    /*issue a get req to hairClientProfile to get their information to display*/
    var response = await http.get(
      Uri.parse("http://192.168.0.11:3000/api/hairClientProfile/" +
          auth.firebaseAuth.currentUser!.uid),
      headers: {
        HttpHeaders.authorizationHeader: _loggedInUserIdToken,
      },
    );
    /*convert the response from string to JSON*/
    var jsonResponse = convert.jsonDecode(response.body);
    List<HairArtistUserProfile> favHairArtistProfiles = [];
    (jsonResponse['favoriteHairArtists'] as List)
        .forEach((backendHairArtistProfile) {
      var hairArtistProfile = HairArtistProfileProvider.createUserProfile(
          backendHairArtistProfile, false);
      favHairArtistProfiles.add(hairArtistProfile);
    }); /*create new HairClient Object object and set the attributes in contructor to build object*/
    _userProfile = new HairClientUserProfile(
      jsonResponse['uid'],
      jsonResponse['email'],
      auth.isHairArtist,
      jsonResponse['profilePhotoUrl'],
      jsonResponse['name'],
      favHairArtistProfiles,
    );
    /*updates the profile object so wigets listen can use its data*/
    notifyListeners();
  }

  Future<void> setName() async {
    await http.put(
      Uri.parse("http://192.168.0.11:3000/api/hairClientProfile/setName/" +
          _userProfile.uid +
          "/"),
      body: {
        'name': _userProfile.name,
      },
      headers: {
        HttpHeaders.authorizationHeader: _loggedInUserIdToken,
      },
    );
    notifyListeners();
  }

  void addProfilePicture(File file) async {
    /*create a storeage ref from firebase*/
    print(file);
    final ref = FirebaseStorage.instance
        .ref()
        .child(_userProfile.email)
        .child("profile_picture");
    /*store the file in firbase storage and call on complete callback*/
    try {
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
                "http://192.168.0.11:3000/api/hairClientProfile/profilepicture"),
            body: {
              'uid': _userProfile.uid,
              'photoUrl': photoUrl,
            },
            headers: {
              HttpHeaders.authorizationHeader: _loggedInUserIdToken,
            },
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  void removeProfilePicture() async {
    void Function() removeProfileAtBackend = () async {
      _userProfile.deleteProfilePhoto();
      http.delete(
        Uri.parse(
            "http://192.168.0.11:3000/api/hairClientProfile/profilepicture"),
        body: {
          'uid': _userProfile.uid,
        },
        headers: {
          HttpHeaders.authorizationHeader: _loggedInUserIdToken,
        },
      );
    };
    _userProfile.deleteProfilePhoto();
    try {
      final ref =
          FirebaseStorage.instance.refFromURL(_userProfile.profilePhotoUrl!);
      await ref.delete().whenComplete(removeProfileAtBackend);
    } catch (e) {
      removeProfileAtBackend();
    }
    notifyListeners();
  }

  Future<void> addHairArtistFavorite(HairArtistUserProfile hairArtist) async {
    _userProfile.addFavourite(hairArtist);
    await http.post(
      Uri.parse(
          "http://192.168.0.11:3000/api/hairClientProfile/favouriteHairArtists"),
      body: {
        'uid': _userProfile.uid,
        'favouriteHairArtists': hairArtist.uid,
      },
      headers: {
        HttpHeaders.authorizationHeader: _loggedInUserIdToken,
      },
    );
    notifyListeners();
  }

  Future<void> removeHairArtistFavorite(String artistUID) async {
    _userProfile.removeFromFavourite(artistUID);
    await http.delete(
      Uri.parse(
          "http://192.168.0.11:3000/api/hairClientProfile/favouriteHairArtists"),
      body: {
        'uid': _userProfile.uid,
        'favouriteHairArtists': artistUID,
      },
      headers: {
        HttpHeaders.authorizationHeader: _loggedInUserIdToken,
      },
    );

    notifyListeners();
  }

  static bool isAFavorite(
      HairClientUserProfile hcup, HairArtistUserProfile haup) {
    if (hcup.favouriteHairArtists.any((favHA) => favHA.uid == haup.uid)) {
      return true;
    }
    return false;
  }
}
