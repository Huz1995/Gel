import 'dart:ui';

import 'package:flutter/material.dart';
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
    Future<void> _showMyDialog(String url) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: Text('DELETE'),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text('Would you like to delete this photo?'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                  onPressed: () async {
                    await _hairArtistProvider.deletePhotoUrl(url);
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    }

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
                          onDoubleTap: () => _showMyDialog(url),
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
