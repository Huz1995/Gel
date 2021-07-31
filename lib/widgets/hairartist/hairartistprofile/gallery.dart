import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gel/providers/custom_dialogs.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:gel/providers/text_size_provider.dart';

class Gallery extends StatelessWidget {
  const Gallery({
    Key? key,
    required HairArtistProfileProvider hairArtistProvider,
    required FontSizeProvider fontSizeProvider,
  })  : _hairArtistProvider = hairArtistProvider,
        _fontSizeProvider = fontSizeProvider,
        super(key: key);

  final HairArtistProfileProvider _hairArtistProvider;
  final FontSizeProvider _fontSizeProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: 50,
      child: _hairArtistProvider.hairArtistProfile.photoUrls.isEmpty
          ? Center(
              child: Container(
                margin: EdgeInsets.only(top: 250.0),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: MediaQuery.of(context).size.width / 7,
                          backgroundColor:
                              Theme.of(context).cardColor.withOpacity(0.1),
                        ),
                        Positioned(
                          left: MediaQuery.of(context).size.width * 0.078,
                          bottom: MediaQuery.of(context).size.width * 0.078,
                          //bottom: _phoneWidth / 4,
                          child: Icon(
                            FontAwesome5.images,
                            size: 50,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        "Upload Images",
                        textAlign: TextAlign.center,
                        style: _fontSizeProvider.headline2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 10, 50, 0),
                      child: Text(
                        "Uploading images is to your portfolio is a key part of gaining exposure and buisiness. Highlight your work and styles to the world!",
                        textAlign: TextAlign.center,
                        style: _fontSizeProvider.bodyText4,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : CustomScrollView(
              slivers: [
                SliverOverlapInjector(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                SliverGrid.count(
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1,
                  crossAxisCount: 2,
                  children: _hairArtistProvider.hairArtistProfile.photoUrls
                      .map(
                        (url) => GestureDetector(
                          onDoubleTap: () =>
                              CustomDialogs.showMyDialogTwoButtons(
                            context,
                            Text('DELETE'),
                            [
                              Text('Would you like to delete this photo?'),
                            ],
                            Text(
                              'Delete',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            ),
                            () async {
                              await _hairArtistProvider.deletePhotoUrl(url);
                              Navigator.of(context).pop();
                            },
                            Text('Cancel'),
                            () {
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
                        ),
                      )
                      .toList(),
                )
              ],
            ),
    );
  }
}
