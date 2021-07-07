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
      width: 50,
      child: _photoUrls.isEmpty
          ? Center(
              child: Text(
                "You have no pictures!, click camera icon to add pictures \n so people can see how amazing your hairfressing is",
              ),
            )
          : CustomScrollView(
              slivers: [
                SliverOverlapInjector(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                SliverGrid.count(
                  crossAxisCount: 2,
                  children: _photoUrls.map((e) => Text(e)).toList(),
                )
              ],
            ),
    );
  }
}
