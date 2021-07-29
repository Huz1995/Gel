import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/widgets/hairartistprofile/gallery_picker.dart';
import 'package:gel/widgets/hairartistprofile/profile_pic_icon.dart';
import 'package:gel/widgets/general_profile/profile_tab_bar.dart';
import 'package:gel/widgets/general/small_button.dart';
import 'package:gel/widgets/hairartistprofile/about.dart';
import 'package:gel/widgets/hairartistprofile/edit_hair_artist_profile_form.dart';
import 'package:gel/widgets/hairartistprofile/gallery.dart';
import 'package:gel/widgets/hairartistprofile/reviews.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:provider/provider.dart';

class HairArtistProfileMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _hairArtistProvider = Provider.of<HairArtistProfileProvider>(context);
    final _fontSizeProvider =
        Provider.of<FontSizeProvider>(context, listen: false);

    String _displayName() {
      if (_hairArtistProvider.hairArtistProfile.about.name == "") {
        String displayEmail =
            "@" + _hairArtistProvider.hairArtistProfile.email.split("@")[0];
        return displayEmail;
      }
      return _hairArtistProvider.hairArtistProfile.about.name;
    }

    final _phoneHeight = MediaQuery.of(context).size.height;
    final _phoneWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 3,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        /*use nested scroll view so child widgets in tab bar scrolling can merge*/
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              /*handler sets the object to be over lapped when scrolling*/
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  actions: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 15, 0),
                      width: 50.0,
                      height: 50.0,
                      child: GalleryPicker(),
                    ),
                  ],
                  elevation: 0,
                  backgroundColor: Colors.white,
                  expandedHeight: _phoneWidth * 0.73,
                  collapsedHeight: _phoneHeight * 0.1,
                  flexibleSpace: LayoutBuilder(
                    builder: (context, constraints) {
                      var top = constraints.biggest.height;
                      return FlexibleSpaceBar(
                        centerTitle: true,
                        title: AnimatedOpacity(
                          opacity: 1,
                          duration: Duration(milliseconds: 0),
                          child: Container(
                            margin: EdgeInsets.only(
                              bottom: _phoneHeight * 0.06,
                            ),
                            child: Text(
                              top >= _phoneHeight * 0.1 &&
                                      top < _phoneHeight * 0.3
                                  ? _displayName()
                                  : "",
                              style: _fontSizeProvider.headline2,
                            ),
                          ),
                        ),
                        background: Column(
                          children: [
                            SizedBox(
                              height: _phoneHeight * 0.08,
                            ),
                            ProfilePicIcon(
                              phoneWidth: _phoneWidth,
                              hairArtistProfileProvider: _hairArtistProvider,
                            ),
                            Padding(
                              padding: EdgeInsets.all(
                                _phoneHeight * 0.015,
                              ),
                              child: Text(
                                _displayName(),
                                style: _fontSizeProvider.headline2,
                              ),
                            ),
                            SmallButton(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text("Edit Profile"),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        new EditHairArtistProfileForm(
                                      _fontSizeProvider,
                                      _hairArtistProvider,
                                    ),
                                  ),
                                );
                              },
                              buttonWidth: 250,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  pinned: true,
                  bottom: ProfileTabBar(),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              Gallery(
                hairArtistProvider: _hairArtistProvider,
                fontSizeProvider: _fontSizeProvider,
              ),
              About(),
              Reviews(),
            ],
          ),
        ),
      ),
    );
  }
}
