import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gel/models/hair_artist_user_profile.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/widgets/general/small_button.dart';
import 'package:gel/widgets/general_profile/hair_artist_about.dart';
import 'package:gel/widgets/general_profile/hair_artist_gallery.dart';
import 'package:gel/widgets/general_profile/profile_tab_bar.dart';
import 'package:gel/widgets/hairartist/profile/edit_hair_artist_profile_form.dart';
import 'package:gel/widgets/hairartist/profile/gallery_picker.dart';

import 'hair_artist_profile_pic_icon.dart';
import 'hair_artist_reviews.dart';

class HairArtistProfileDisplay extends StatelessWidget {
  const HairArtistProfileDisplay(
      {Key? key,
      required double phoneWidth,
      required double phoneHeight,
      HairArtistProfileProvider? hairArtistProvider,
      required HairArtistUserProfile hairArtistUserProfile,
      required FontSizeProvider fontSizeProvider,
      required bool isForDisplay,
      required})
      : _phoneWidth = phoneWidth,
        _phoneHeight = phoneHeight,
        _hairArtistProvider = hairArtistProvider,
        _isForDisplay = isForDisplay,
        _fontSizeProvider = fontSizeProvider,
        _hairArtistUserProfile = hairArtistUserProfile,
        super(key: key);

  final double _phoneWidth;
  final double _phoneHeight;
  final HairArtistProfileProvider? _hairArtistProvider;
  final FontSizeProvider _fontSizeProvider;
  final HairArtistUserProfile _hairArtistUserProfile;
  final bool _isForDisplay;

  @override
  Widget build(BuildContext context) {
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
                  leading: Container(
                    margin: EdgeInsets.fromLTRB(15, 10, 0, 0),
                    child: TextButton(
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                        size: 30,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  actions: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 15, 0),
                      width: 50.0,
                      height: 50.0,
                      child: !_isForDisplay
                          ? GalleryPicker()
                          : Icon(
                              MaterialIcons.favorite_border,
                              color: Theme.of(context).accentColor,
                              size: 30,
                            ),
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
                                  ? _hairArtistUserProfile.about.name
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
                            !_isForDisplay
                                ? HairArtistProfilePicIcon(
                                    phoneWidth: _phoneWidth,
                                    hairArtistProfileProvider:
                                        _hairArtistProvider!,
                                    hairArtistUserProfile:
                                        _hairArtistUserProfile,
                                    isForDisplay: _isForDisplay,
                                  )
                                : HairArtistProfilePicIcon(
                                    phoneWidth: _phoneWidth,
                                    hairArtistUserProfile:
                                        _hairArtistUserProfile,
                                    isForDisplay: _isForDisplay,
                                  ),
                            Padding(
                              padding: EdgeInsets.all(
                                _phoneHeight * 0.015,
                              ),
                              child: Text(
                                _hairArtistUserProfile.about.name,
                                style: _fontSizeProvider.headline2,
                              ),
                            ),
                            !_isForDisplay
                                ? SmallButton(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    child: Text("Edit Profile"),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new EditHairArtistProfileForm(
                                            _fontSizeProvider,
                                            _hairArtistProvider!,
                                          ),
                                        ),
                                      );
                                    },
                                    buttonWidth: 250,
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SmallButton(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        child: Text("Call"),
                                        buttonWidth: 125,
                                        onPressed: () {},
                                      ),
                                      SizedBox(width: 10),
                                      SmallButton(
                                        backgroundColor:
                                            Theme.of(context).accentColor,
                                        child: Text("Message"),
                                        buttonWidth: 125,
                                        onPressed: () {},
                                      )
                                    ],
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
              !_isForDisplay
                  ? HairArtistGallery(
                      hairArtistProvider: _hairArtistProvider,
                      fontSizeProvider: _fontSizeProvider,
                      isForDisplay: _isForDisplay,
                      hairArtistUserProfile: _hairArtistUserProfile,
                    )
                  : HairArtistGallery(
                      hairArtistUserProfile: _hairArtistUserProfile,
                      isForDisplay: _isForDisplay,
                      fontSizeProvider: _fontSizeProvider,
                    ),
              HairArtistAbout(
                hairArtistUserProfile: _hairArtistUserProfile,
                fontSizeProvider: _fontSizeProvider,
              ),
              HairArtistReviews(),
            ],
          ),
        ),
      ),
    );
  }
}
