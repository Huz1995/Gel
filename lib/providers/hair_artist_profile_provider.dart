import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gel/models/hair_artist_user_profile.dart';
import 'package:gel/models/location.dart';
import 'package:gel/models/review_model.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

/*this provider manages the state for a hair artist profile page that 
can be edited by the artist*/
class HairArtistProfileProvider extends ChangeNotifier {
  HairArtistUserProfile _userProfile = HairArtistUserProfile(
      "",
      "",
      false,
      [],
      null,
      HairArtistAboutInfo("", "", "", "", "", "", "", "", "", "", ""),
      null,
      [],
      0,
      0,
      []);
  /*this token is used to send headers to back end to protect routes*/
  late String _loggedInUserIdToken;
  late AuthenticationProvider _auth;

  /*chat state values*/
  late String activeUser;
  late String activeRoom;

  /*when the provider is init, send the auth provider to store the logged in user token
  so can protect the routes on the back end*/
  HairArtistProfileProvider(AuthenticationProvider auth) {
    /* when we initate the hair artist profile then get the user data from the back end*/
    _loggedInUserIdToken = auth.idToken;
    _auth = auth;
  }

  /*function that return the hair artist user object*/
  HairArtistUserProfile get hairArtistProfile {
    return _userProfile;
  }

  /*static funtion that takes in a json reponse. this json data contains the raw hair artist
  data defined by their uid from the hair artist collection from the back end and 
  returns a HairArtistUserProfile object defined by the front end models*/
  static Future<HairArtistUserProfile> createUserProfile(dynamic jsonResponse,
      bool withLocation, String loggedInUserIdToken) async {
    /*sometimes we want the location of the artist, others not needed so can choose to set
    location object to null or not through the boolean*/
    Location? location = withLocation
        ? Location(
            lng: jsonResponse['location']['coordinates'][0],
            lat: jsonResponse['location']['coordinates'][1],
          )
        : null;
    HairArtistAboutInfo about = new HairArtistAboutInfo(
      jsonResponse['about']['name'],
      jsonResponse['about']['contactNumber'],
      jsonResponse['about']['dialCode'],
      jsonResponse['about']['isoCode'],
      jsonResponse['about']['instaUrl'],
      jsonResponse['about']['description'],
      jsonResponse['about']['chatiness'],
      jsonResponse['about']['workingArrangement'],
      jsonResponse['about']['previousWorkExperience'],
      jsonResponse['about']['hairTypes'],
      jsonResponse['about']['hairServCost'],
    );
    return new HairArtistUserProfile(
      jsonResponse['uid'],
      jsonResponse['email'],
      jsonResponse['isHairArtist:'],
      (jsonResponse['photoUrls'] as List).cast<String>(),
      jsonResponse['profilePhotoUrl'],
      about,
      location,
      await _getReviews(jsonResponse['reviews'], loggedInUserIdToken),
      jsonResponse['numReviews'],
      jsonResponse['totalScore'],
      (jsonResponse['hairClientMessagingUids'] as List).cast<String>(),
    );
  }

  /*function that gets the reviews the hair artist contains, the previous
  json object sent from the back end has reviews thats contan the reviwer uid ,
  so need to take the uid and send a get request to the backend to get the reviwers, profile photo
  url and name*/
  static Future<List<Review>> _getReviews(
      dynamic jsonReviews, String loggedInUserIdToken) async {
    List<Review> reviews = [];
    /*convert json object to list*/
    List<dynamic> reviewList = (jsonReviews as List);
    for (int i = 0; i < reviewList.length; i++) {
      /*itr through list and get reviwer details*/
      var response = await http.get(
        Uri.parse("http://192.168.0.11:3000/api/hairClientProfile/reviewer/" +
            reviewList[i]['reviewerUID']),
        headers: {
          HttpHeaders.authorizationHeader: loggedInUserIdToken,
        },
      );
      /*create review object out of input jsonreviews and response*/
      var jsonResponse = convert.jsonDecode(response.body);
      var reviewObj = Review(
        reviewList[i]['_id'],
        reviewList[i]['score'],
        reviewList[i]['body'],
        jsonResponse['reviewerProfilePhotoUrl'],
        jsonResponse['reviewerName'],
        reviewList[i]['reviewerUID'],
        DateTime.parse(reviewList[i]['datetime']),
      );
      /*add to list*/
      reviews.add(reviewObj);
    }
    /*return rreviews*/
    return reviews;
  }

  Future<void> getUserDataFromBackend() async {
    /*issue a get req to hairArtistProfile to get their information to display*/
    http.get(
      Uri.parse("http://192.168.0.11:3000/api/hairArtistProfile/" +
          _auth.firebaseAuth.currentUser!.uid),
      headers: {
        HttpHeaders.authorizationHeader: _loggedInUserIdToken,
      },
    ).then(
      (response) async {
        /*convert the response from string to JSON*/
        var jsonResponse = convert.jsonDecode(response.body);
        /*create new Hair artist about info object*/
        _userProfile =
            await createUserProfile(jsonResponse, false, _loggedInUserIdToken);
        /*updates the profile object so wigets listen can use its data*/
        notifyListeners();
      },
    );
  }

  Future<void> saveNewImage(File file) async {
    /*create a storeage ref from firebase create a path using the user email
    and amount of pictures*/
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
        /*send the url to backend and store in mongodb for persistance*/
        await http.put(
          Uri.parse("http://192.168.0.11:3000/api/hairArtistProfile/photos"),
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
    notifyListeners();
  }

  void addProfilePicture(File file) async {
    /*create a storeage ref from firebase and create path using a user email*/
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
                "http://192.168.0.11:3000/api/hairArtistProfile/profilepicture"),
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
            "http://192.168.0.11:3000/api/hairArtistProfile/profilepicture"),
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

  /*about ui form updates the object aabout data, take that data and store in backend*/
  Future<void> setAboutDetails() async {
    await http.put(
      Uri.parse("http://192.168.0.11:3000/api/hairArtistProfile/about/" +
          _userProfile.uid +
          "/"),
      body: _userProfile.about.toObject(),
      headers: {
        HttpHeaders.authorizationHeader: _loggedInUserIdToken,
      },
    );
    notifyListeners();
  }

  /*funciton that takes a photo url removes from db and storeage*/
  Future<void> deletePhotoUrl(String url) async {
    /*create a firebase reference from url*/
    final ref = FirebaseStorage.instance.refFromURL(url);
    await ref.delete().whenComplete(
      () async {
        _userProfile.deletePhotoUrl(url);
        http.delete(
          Uri.parse("http://192.168.0.11:3000/api/hairArtistProfile/photos"),
          body: {
            'uid': _userProfile.uid,
            'photoUrl': url,
          },
          headers: {
            HttpHeaders.authorizationHeader: _loggedInUserIdToken,
          },
        );
      },
    );
    notifyListeners();
  }

  /*function that takes in lat,lng and stores it in the databse*/
  Future<void> updateHairArtistLocation(double lat, double lng) async {
    await http.put(
      Uri.parse("http://192.168.0.11:3000/api/hairArtistProfile/location/" +
          _userProfile.uid +
          "/"),
      body: {
        'lat': lat.toString(),
        'lng': lng.toString(),
      },
      headers: {
        HttpHeaders.authorizationHeader: _loggedInUserIdToken,
      },
    );
  }
}
