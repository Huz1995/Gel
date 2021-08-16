import 'package:flutter/material.dart';
import 'package:gel/models/hair_artist_user_profile.dart';
import 'package:gel/models/review_model.dart';
import 'package:gel/providers/hair_client_profile_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/providers/ui_service.dart';
import 'package:gel/widgets/general/long_button.dart';
import 'package:gel/widgets/general_profile/review_widget.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';

import 'hair_artist_review_total_score.dart';

class HairArtistReviews extends StatefulWidget {
  late bool? isForDisplay;
  late HairArtistUserProfile? hairArtistUserProfile;
  late HairClientProfileProvider? hairClientProfileProvider;
  late double _averageScore;

  HairArtistReviews({
    this.isForDisplay,
    this.hairArtistUserProfile,
    this.hairClientProfileProvider,
  }) {
    if (hairArtistUserProfile!.numReviews != 0) {
      _averageScore =
          hairArtistUserProfile!.totalScore / hairArtistUserProfile!.numReviews;
    } else {
      _averageScore = 0;
    }
  }

  @override
  _HairArtistReviewsState createState() => _HairArtistReviewsState();
}

class _HairArtistReviewsState extends State<HairArtistReviews> {
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
        onSubmitted: (response) async {
          print('rating: ${response.rating}, comment: ${response.comment}');
          Review review = Review(
              null,
              response.rating,
              response.comment,
              widget
                  .hairClientProfileProvider!.hairClientProfile.profilePhotoUrl,
              widget.hairClientProfileProvider!.hairClientProfile.name,
              widget.hairClientProfileProvider!.hairClientProfile.uid,
              DateTime.now());

          var _id = await widget.hairClientProfileProvider!
              .addReviewToHairArtist(widget.hairArtistUserProfile!, review);
          review.addId(_id);
          print(_id);
          setState(
            () {
              widget.hairArtistUserProfile!.addReview(review);
              widget.hairArtistUserProfile!.addToTotalScore(review.score);
              widget.hairArtistUserProfile!.addOneToReviewCount();
              widget._averageScore =
                  widget.hairArtistUserProfile!.getAverageScore();
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _reviews = widget.hairArtistUserProfile!.reviews;
    void removeReviewFromState(Review review) {
      widget.hairClientProfileProvider!
          .removeReviewFromHairArtist(widget.hairArtistUserProfile!, review);
      setState(() {
        widget.hairArtistUserProfile!.removeFromTotalScore(review.score);
        widget.hairArtistUserProfile!.removeOneFromReviewCount();
        widget.hairArtistUserProfile!.removeReview(review);
        widget._averageScore = widget.hairArtistUserProfile!.getAverageScore();
      });
    }

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
                score: widget._averageScore,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 200,
                  width: double.infinity,
                  child: _reviews.isEmpty
                      ? UIService.noElementsToShowMessage(
                          context,
                          widget.isForDisplay!,
                          Icon(
                            Icons.rate_review_outlined,
                            size: 50,
                          ),
                          "No one has left a review to the artist, be the first!",
                          "No one has left you a review",
                          "")
                      : CustomScrollView(
                          slivers: [
                            SliverList(
                              delegate: SliverChildListDelegate(
                                _reviews
                                    .map((review) => ReviewWidget(
                                          review: review,
                                          hairClientUid: widget
                                              .hairClientProfileProvider!
                                              .hairClientProfile
                                              .uid,
                                          removeReviewFromState:
                                              removeReviewFromState,
                                        ))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              widget.isForDisplay!
                  ? Container(
                      height: 80,
                      child: Center(
                        child: Column(
                          children: [
                            LongButton(
                                backgroundColor: Theme.of(context).primaryColor,
                                onPressed:
                                    // () => showDialog(
                                    //     context: context,
                                    //     builder: buildRatingDialog),
                                    () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: buildRatingDialog));
                                },
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
