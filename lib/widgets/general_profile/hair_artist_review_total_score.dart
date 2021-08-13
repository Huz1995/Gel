import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class HairArtistReviewTotalScore extends StatelessWidget {
  late double? score;

  HairArtistReviewTotalScore({this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.all(20),
        child: RatingBarIndicator(
          rating: score!,
          itemBuilder: (context, index) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          itemCount: 5,
          itemSize: 30.0,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
        ),
      ),
    );
  }
}
