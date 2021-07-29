import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gel/providers/custom_dialogs.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';

class Gallery extends StatelessWidget {
  const Gallery({
    Key? key,
    required HairArtistProfileProvider hairArtistProvider,
  })  : _hairArtistProvider = hairArtistProvider,
        super(key: key);

  final HairArtistProfileProvider _hairArtistProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: 50,
      child: _hairArtistProvider.hairArtistProfile.photoUrls.isEmpty
          ? Center(
              child: Container(
                margin: EdgeInsets.all(50.0),
                child: Text(
                  "You have no pictures!, click camera icon to add before and after photos of your hair cut so people can see what an amazing hairdresser you are!",
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
