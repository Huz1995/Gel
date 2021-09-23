import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gel/models/hair_artist_user_profile.dart';
import 'package:gel/models/review_model.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/providers/ui_service.dart';
import 'package:provider/provider.dart';

class ReviewWidget extends StatefulWidget {
  late Review? review;
  late String? hairClientUid;
  late void Function(Review review)? removeReviewFromState;
  ReviewWidget({this.review, this.hairClientUid, this.removeReviewFromState});

  @override
  _ReviewWidgetState createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  @override
  Widget build(BuildContext context) {
    var _fontSizeProvider = Provider.of<FontSizeProvider>(context);
    return Container(
      padding: const EdgeInsets.all(10.0),
      height: 230,
      child: GestureDetector(
        onDoubleTap: () {
          if (widget.hairClientUid != null) {
            if (widget.review!.reviewerUid == widget.hairClientUid!) {
              widget.removeReviewFromState!(widget.review!);
            }
          } else
            print("nothing");
        },
        child: Container(
          margin: EdgeInsets.all(10),
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).primaryColor.withOpacity(0.5),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.fromLTRB(4, 4, 0, 0),
                child: Column(
                  children: [
                    RatingBarIndicator(
                      rating: widget.review!.score.toDouble(),
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 20.0,
                    ),
                    SizedBox(height: 10),
                    UIService.getProfilePicIcon(
                        hasProfilePic:
                            (widget.review!.reviewerProfilePhotoUrl != null),
                        context: context,
                        url: widget.review!.reviewerProfilePhotoUrl,
                        radius: 40),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.review!.reviewerName,
                      style: _fontSizeProvider.headline4,
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: SingleChildScrollView(
                    child: Container(
                      child: Text(widget.review!.body),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
