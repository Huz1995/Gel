import 'package:flutter/material.dart';
import 'package:gel/models/hair_artist_user_profile.dart';
import 'package:gel/models/hair_client_user_profile.dart';
import 'package:gel/models/review_model.dart';
import 'package:gel/providers/hair_client_profile_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/providers/ui_service.dart';
import 'package:gel/widgets/general/long_button.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';

import 'hair_artist_review_total_score.dart';

class HairArtistReviews extends StatefulWidget {
  late bool? isForDisplay;
  late HairArtistUserProfile? hairArtistUserProfile;
  late HairClientProfileProvider? hairClientProfileProvider;

  HairArtistReviews({
    this.isForDisplay,
    this.hairArtistUserProfile,
    this.hairClientProfileProvider,
  });

  @override
  _HairArtistReviewsState createState() => _HairArtistReviewsState();
}

class _HairArtistReviewsState extends State<HairArtistReviews> {
  final _array = [
    Text("ds"),
    Text("ds"),
    Text("ds"),
    Text("ds"),
    Text("ds"),
    Text("ds"),
    Text("ds"),
    Text("ds"),
    Text("ds"),
    Text("ds"),
    Text("ds"),
    Text("ds"),
    Text("ds"),
    Text("ds"),
    Text("ds"),
    Text("ds"),
  ];

  Widget buildRatingDialog(BuildContext context) {
    return SafeArea(
      child: RatingDialog(
        // your app's name?
        title: 'What you think of the Artist',
        // encourage your user to leave a high rating?
        message:
            'Tap a star to set your rating. Add more description here if you want.',
        // your app's logo?
        image: UIService.getProfilePicIcon(
            widget.hairArtistUserProfile!.profilePhotoUrl != null,
            context,
            widget.hairArtistUserProfile!.profilePhotoUrl),
        submitButton: 'Submit',
        onSubmitted: (response) {
          print('rating: ${response.rating}, comment: ${response.comment}');
          Review review = Review(
              response.rating,
              response.comment,
              widget.hairClientProfileProvider!.hairClientProfile,
              DateTime.now());
          widget.hairClientProfileProvider!
              .addReviewToHairArtist(widget.hairArtistUserProfile!, review);
          // setState(() {
          //   widget.isForDisplay = false;
          // });
          // TODO: add your own logic
          // if (response.rating < 3.0) {
          //   // send their comments to your email or anywhere you wish
          //   // ask the user to contact you instead of leaving a bad review
          // } else {}
          // setState(() {
          //   widget.isForDisplay = false;
          // });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FontSizeProvider(context),
      child: Scaffold(
        body: Center(
          widthFactor: double.infinity,
          heightFactor: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: 180,
              ),
              HairArtistReviewTotalScore(
                score: 4.4,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 200,
                  width: double.infinity,
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate(
                          _array,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              widget.isForDisplay!
                  ? Container(
                      height: 100,
                      padding: EdgeInsets.only(top: 15),
                      child: Center(
                        child: Column(
                          children: [
                            LongButton(
                                backgroundColor: Theme.of(context).primaryColor,
                                onPressed: () => showDialog(
                                    context: context,
                                    builder: buildRatingDialog),
                                buttonName: "Add Review")
                          ],
                        ),
                      ),
                    )
                  : Text(""),
            ],
          ),
        ),
      ),
    );
  }
}
