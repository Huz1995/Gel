import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gel/models/hair_artist_user_profile.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:gel/providers/hair_client_profile_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/providers/ui_service.dart';
import 'package:gel/widgets/general_profile/hair_artist_profile_display.dart';
import 'package:provider/provider.dart';

class FavouriteWidget extends StatelessWidget {
  late int? listIndex;
  late HairArtistUserProfile? hairArtistUserProfile;

  FavouriteWidget({this.listIndex, this.hairArtistUserProfile});

  @override
  Widget build(BuildContext context) {
    final _fontSizeProvider = Provider.of<FontSizeProvider>(context);
    final _hairClientProfileProvider =
        Provider.of<HairClientProfileProvider>(context);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          height: 200,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: listIndex! % 2 == 0
                ? Theme.of(context).primaryColor.withOpacity(0.2)
                : Theme.of(context).accentColor.withOpacity(0.2),
            elevation: 20,
            child: TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HairArtistProfileDisplay(
                      phoneWidth: MediaQuery.of(context).size.width,
                      phoneHeight: MediaQuery.of(context).size.height,
                      hairArtistUserProfile: hairArtistUserProfile!,
                      hairClientProfileProvider: _hairClientProfileProvider,
                      fontSizeProvider: _fontSizeProvider,
                      isFavOfClient: HairClientProfileProvider.isAFavorite(
                          _hairClientProfileProvider.hairClientProfile,
                          hairArtistUserProfile!),
                      isForDisplay: true),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.fromLTRB(4, 4, 0, 0),
                    child: Column(
                      children: [
                        UIService.getProfilePicIcon(
                            (hairArtistUserProfile!.profilePhotoUrl != null),
                            context,
                            hairArtistUserProfile!.profilePhotoUrl),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          hairArtistUserProfile!.about.name,
                          style: _fontSizeProvider.headline4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
