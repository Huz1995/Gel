import 'package:gel/models/location.dart';
import 'package:gel/models/review_model.dart';

class HairArtistAboutInfo {
  String name;
  String contactNumber;
  String dialCode;
  String isoCode;
  String instaUrl;
  String description;
  String chatiness;
  String workingArrangement;
  String previousWorkExperience;
  String hairTypes;
  String hairServCost;

  HairArtistAboutInfo(
    this.name,
    this.contactNumber,
    this.dialCode,
    this.isoCode,
    this.instaUrl,
    this.description,
    this.chatiness,
    this.workingArrangement,
    this.previousWorkExperience,
    this.hairTypes,
    this.hairServCost,
  );

  Map<String, String> toObject() {
    return {
      'name': name,
      'contactNumber': contactNumber,
      'dialCode': dialCode,
      'isoCode': isoCode,
      'instaUrl': instaUrl,
      'description': description,
      'chatiness': chatiness,
      'workingArrangement': workingArrangement,
      'previousWorkExperience': previousWorkExperience,
      'hairTypes': hairTypes,
      'hairServCost': hairServCost,
    };
  }
}

class HairArtistUserProfile {
  String _uid;
  String _email;
  bool _isHairArtist;
  List<String> _photoUrls;
  String? _profilePhotoUrl;
  HairArtistAboutInfo _about;
  Location? _location;
  List<Review> _reviews;
  int _numReviews;
  int _totalScore;

  HairArtistUserProfile(
    this._uid,
    this._email,
    this._isHairArtist,
    this._photoUrls,
    this._profilePhotoUrl,
    this._about,
    this._location,
    this._reviews,
    this._numReviews,
    this._totalScore,
  );

  String get uid {
    return _uid;
  }

  String get email {
    return _email;
  }

  bool get isHairArtist {
    return _isHairArtist;
  }

  List<String> get photoUrls {
    return _photoUrls;
  }

  String? get profilePhotoUrl {
    return _profilePhotoUrl;
  }

  HairArtistAboutInfo get about {
    return _about;
  }

  Location? get location {
    return _location;
  }

  int get numReviews {
    return _numReviews;
  }

  int get totalScore {
    return _totalScore;
  }

  List<Review> get reviews {
    return _reviews;
  }

  /*this adds a photo url to the array*/
  void addPhotoUrl(String url) {
    this._photoUrls.insert(0, url);
  }

  void addProfilePictureUrl(String url) {
    this._profilePhotoUrl = url;
  }

  void deletePhotoUrl(String url) {
    this._photoUrls.remove(url);
  }

  void deleteProfilePhoto() {
    this._profilePhotoUrl = null;
  }

  void addOneToReviewCount() {
    this._numReviews += 1;
  }

  void removeOneFromReviewCount() {
    this._numReviews -= 1;
  }

  void addToTotalScore(int score) {
    this._totalScore += score;
  }

  void removeFromTotalScore(int score) {
    this._totalScore -= score;
  }

  void addReview(Review review) {
    _reviews.insert(0, review);
  }

  void removeReview(Review review) {
    _reviews.remove(review);
  }

  double getAverageScore() {
    if (numReviews != 0) {
      return _totalScore / _numReviews;
    }
    return 0;
  }
}
