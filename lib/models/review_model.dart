import 'package:gel/models/hair_client_user_profile.dart';

class Review {
  late String? _id;
  late int score;
  late String body;
  String? reviewerProfilePhotoUrl;
  String reviewerName;
  String reviewerUid;
  late DateTime dateTime;

  Review(this._id, this.score, this.body, this.reviewerProfilePhotoUrl,
      this.reviewerName, this.reviewerUid, this.dateTime);

  void addId(String id) {
    this._id = id;
  }

  String get id {
    return _id!;
  }
}
