import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gel/models/hair_artist_user_profile.dart';
import 'package:gel/providers/custom_dialogs.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/providers/ui_service.dart';

class HairArtistGallery extends StatelessWidget {
  const HairArtistGallery({
    Key? key,
    HairArtistProfileProvider? hairArtistProvider,
    required FontSizeProvider fontSizeProvider,
    required HairArtistUserProfile hairArtistUserProfile,
    required bool isForDisplay,
  })  : _hairArtistProvider = hairArtistProvider,
        _fontSizeProvider = fontSizeProvider,
        _isForDisplay = isForDisplay,
        _hairArtistUserProfile = hairArtistUserProfile,
        super(key: key);

  final HairArtistProfileProvider? _hairArtistProvider;
  final FontSizeProvider _fontSizeProvider;
  final bool _isForDisplay;
  final HairArtistUserProfile _hairArtistUserProfile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        widthFactor: double.infinity,
        heightFactor: double.infinity,
        child: Container(
          padding: EdgeInsets.all(10),
          width: double.infinity,
          child: _hairArtistUserProfile.photoUrls.isEmpty
              ? Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.25),
                  child: UIService.noElementsToShowMessage(
                    context,
                    _isForDisplay,
                    Icon(
                      FontAwesome5.images,
                      size: 50,
                    ),
                    "Artist Has No Images",
                    "Upload Images",
                    "Uploading images is to your portfolio is a key part of gaining exposure and buisiness. Highlight your work and styles to the world!",
                  ),
                )
              : CustomScrollView(
                  slivers: [
                    SliverOverlapInjector(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                    ),
                    SliverGrid.count(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1,
                      crossAxisCount: 2,
                      children: _hairArtistUserProfile.photoUrls.map(
                        (url) {
                          if (!_isForDisplay) {
                            return GestureDetector(
                              onDoubleTap: () =>
                                  CustomDialogs.showMyDialogTwoButtons(
                                context: context,
                                title: Text('DELETE'),
                                body: [
                                  Text('Would you like to delete this photo?')
                                ],
                                buttonOnechild: Text(
                                  'Delete',
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor),
                                ),
                                buttonOneOnPressed: () async {
                                  await _hairArtistProvider!
                                      .deletePhotoUrl(url);
                                  Navigator.of(context).pop();
                                },
                                buttonTwochild: Text('Cancel'),
                                buttonTwoOnPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(url),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          }
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(url),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
