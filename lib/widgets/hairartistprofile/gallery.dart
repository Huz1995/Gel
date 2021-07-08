import 'dart:io';

import 'package:flutter/material.dart';

class Gallery extends StatelessWidget {
  const Gallery({
    Key? key,
    required List<String> photoUrls,
  })  : _photoUrls = photoUrls,
        super(key: key);

  final List<String> _photoUrls;
  @override
  Widget build(BuildContext context) {
    print(_photoUrls);
    return Container(
      padding: EdgeInsets.all(10),
      width: 50,
      child: _photoUrls.isEmpty
          ? Center(
              child: Text(
                "You have no pictures!, click camera icon to add before and after photos of your hair cut so people can see what an amazing hairdresser you are!",
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
                  children: _photoUrls
                      .map(
                        (url) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(url),
                              fit: BoxFit.cover,
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
