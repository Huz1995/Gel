import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gel/models/hair_artist_user_profile.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:gel/providers/hair_client_profile_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/providers/ui_service.dart';
import 'package:gel/widgets/general_profile/hair_artist_profile_display.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FavouriteWidget extends StatelessWidget {
  late int? listIndex;
  late HairArtistUserProfile? hairArtistUserProfile;

  FavouriteWidget({this.listIndex, this.hairArtistUserProfile});

  Widget build(BuildContext context) {
    final _fontSizeProvider = Provider.of<FontSizeProvider>(context);
    final _hairClientProfileProvider =
        Provider.of<HairClientProfileProvider>(context);

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => HairArtistProfileDisplay(
            hairArtistUserProfile: hairArtistUserProfile!,
            hairClientProfileProvider: _hairClientProfileProvider,
            fontSizeProvider: _fontSizeProvider,
            isFavOfClient: HairClientProfileProvider.isAFavorite(
                _hairClientProfileProvider.hairClientProfile,
                hairArtistUserProfile!),
            isForDisplay: true,
            isDisplayForArtist: false,
          ),
        ),
      ),
      child: Container(
        //padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Container(
          margin: EdgeInsets.fromLTRB(1, 10, 1, 10),
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            color: Theme.of(context).primaryColor.withOpacity(0.5),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 16,
                    ),
                    UIService.getProfilePicIcon(
                        hasProfilePic:
                            (hairArtistUserProfile!.profilePhotoUrl != null),
                        context: context,
                        url: hairArtistUserProfile!.profilePhotoUrl,
                        radius: 30),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 20, 0, 0),
                              child: Text(
                                hairArtistUserProfile!.about.name,
                                style: _fontSizeProvider.headline4,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RatingBarIndicator(
                              rating: hairArtistUserProfile!.getAverageScore(),
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 30.0,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 2.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
