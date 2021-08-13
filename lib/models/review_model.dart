import 'package:gel/models/hair_client_user_profile.dart';

class Review {
  late int score;
  late String body;
  late HairClientUserProfile reviewer;
  late DateTime dateTime;

  Review(this.score, this.body, this.reviewer, this.dateTime);
}
