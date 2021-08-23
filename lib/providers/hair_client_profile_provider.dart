import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gel/models/hair_artist_user_profile.dart';
import 'package:gel/models/hair_client_user_profile.dart';
import 'package:gel/models/review_model.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HairClientProfileProvider extends ChangeNotifier {
  HairClientUserProfile _userProfile =
      HairClientUserProfile("", "", false, "", "", [], []);
  /*this token is used to send headers to back end to protect routes*/
  late String _loggedInUserIdToken;
  int _hairClientBottomNavBarState = 2;
  String? _newArtistUIDForMessages;

  /*when the provider is init, send the auth provider to store the logged in user token
  so can protect the routes on the back end*/
  HairClientProfileProvider(AuthenticationProvider auth) {
    /* when we initate the hair client profile then get the user data from the back end*/
    _loggedInUserIdToken = auth.idToken;
  }

  int get hairClientBottomNavBarState {
    return _hairClientBottomNavBarState;
  }

  void setHairClientBottomNavBarState(int stateNumber) {
    _hairClientBottomNavBarState = stateNumber;
    notifyListeners();
  }

  /*function that return the hair client user object*/
  HairClientUserProfile get hairClientProfile {
    return _userProfile;
  }

  /*function that gets the client data form the backend when logs in*/
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
    /*for the favorite hair artits the client has need to form
    HairArtistUserProfies and store in a list in the client object*/
    List<HairArtistUserProfile> favHairArtistProfiles = [];
    List<dynamic> backendHairArtistProfiles =
        (jsonResponse['favoriteHairArtists'] as List);
    for (int i = 0; i < backendHairArtistProfiles.length; i++) {
      /*we use the HairArtistProfileProvider static method to create a user profile
      out of the raw jsonResponse coming in from the backend*/
      var hairArtistProfile = await HairArtistProfileProvider.createUserProfile(
          backendHairArtistProfiles[i], false, _loggedInUserIdToken);
      /*store the object in list*/
      favHairArtistProfiles.add(hairArtistProfile);
    }
    print(jsonResponse['hairArtistMessagingUids']);
    /*create new HairClient Object object and set the attributes in contructor to build object*/
    _userProfile = new HairClientUserProfile(
      jsonResponse['uid'],
      jsonResponse['email'],
      auth.isHairArtist,
      jsonResponse['profilePhotoUrl'],
      jsonResponse['name'],
      favHairArtistProfiles,
      (jsonResponse['hairArtistMessagingUids'] as List).cast<String>(),
    );
    print(_userProfile.name);
    /*updates the profile object so wigets listen can use its data*/
    notifyListeners();
  }

  /*function that takes in a name form edit profile widget and then stores in db*/
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
    /*create a storeage ref from firebase and create path using a user email*/
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

  /*function that reviews a profile picture*/
  void removeProfilePicture() async {
    void Function() removeProfileAtBackend = () async {
      /*remove from user profile object for ui*/
      _userProfile.deleteProfilePhoto();
      /*remove from the database*/
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
    /*create a ref from the url and delete it*/
    try {
      final ref =
          FirebaseStorage.instance.refFromURL(_userProfile.profilePhotoUrl!);
      await ref.delete().whenComplete(removeProfileAtBackend);
    } catch (e) {
      removeProfileAtBackend();
    }
    notifyListeners();
  }

  /*function that adds favorite hair artist to the hair client profile and db*/
  Future<void> addHairArtistFavorite(HairArtistUserProfile hairArtist) async {
    /*add to favs to update ui*/
    _userProfile.addFavourite(hairArtist);
    /*just post the uid, the back end will fetch the profile when the client logs on*/
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

  /*function that removes the hair artist from the ui and db*/
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

  /*static function that checks if the hairclient user object has hair artist as a fav*/
  static bool isAFavorite(
      HairClientUserProfile hcup, HairArtistUserProfile haup) {
    if (hcup.favouriteHairArtists.any((favHA) => favHA.uid == haup.uid)) {
      return true;
    }
    return false;
  }

  /*function that adds a review from hair client to the hair artist profile in
  the back end*/
  Future<String> addReviewToHairArtist(
      HairArtistUserProfile hairArtistUserProfile, Review review) async {
    /*take the hair artist user profile and and the review object created by the hair client
    send to the back end so can store the review details in the hair artist profile*/
    var response = await http.post(
      Uri.parse("http://192.168.0.11:3000/api/hairArtistProfile/review"),
      body: {
        'hairArtistUid': hairArtistUserProfile.uid,
        'score': review.score.toString(),
        'body': review.body,
        'datetime': review.dateTime.toString(),
        'hairClientUid': _userProfile.uid,
      },
      headers: {
        HttpHeaders.authorizationHeader: _loggedInUserIdToken,
      },
    );
    /*the reponse contains and id of the response sub-object that is create by mongodb,
    we take this id and store it in the review object in the ui so if the user deletes it issuing another
    get req toget the reviews for artsist, they can delete it by matching the id's in the db*/
    var jsonResponse = convert.jsonDecode(response.body);
    return jsonResponse['_id'];
  }

  /*function that removes the review from hair artsis profile if
  user who created review double taps and deletes it*/
  Future<void> removeReviewFromHairArtist(
      HairArtistUserProfile hairArtistUserProfile, Review review) async {
    await http.delete(
      Uri.parse("http://192.168.0.11:3000/api/hairArtistProfile/review"),
      body: {
        'hairArtistUid': hairArtistUserProfile.uid,
        'reviewId': review.id,
        'score': review.score.toString(),
      },
      headers: {
        HttpHeaders.authorizationHeader: _loggedInUserIdToken,
      },
    );
  }

  void setnewArtistUIDForMessages(String? artistUID) {
    _newArtistUIDForMessages = artistUID;
  }

  String? get newArtistUIDForMessages {
    return _newArtistUIDForMessages;
  }
}
