import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gel/models/hair_artist_user_profile.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:gel/providers/hair_client_profile_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/widgets/general/small_button.dart';
import 'package:gel/widgets/general_profile/hair_artist_about.dart';
import 'package:gel/widgets/general_profile/hair_artist_gallery.dart';
import 'package:gel/widgets/general_profile/profile_tab_bar.dart';
import 'package:gel/widgets/hairartist/profile/edit_hair_artist_profile_form.dart';
import 'package:gel/widgets/hairartist/profile/gallery_picker.dart';
import 'package:provider/provider.dart';

import 'hair_artist_profile_pic_icon.dart';
import 'hair_artist_reviews.dart';

class HairArtistProfileDisplay extends StatefulWidget {
  HairArtistProfileDisplay(
      {Key? key,
      required double phoneWidth,
      required double phoneHeight,
      HairArtistProfileProvider? hairArtistProvider,
      HairClientProfileProvider? hairClientProfileProvider,
      required HairArtistUserProfile hairArtistUserProfile,
      required FontSizeProvider fontSizeProvider,
      required bool isForDisplay,
      bool? isFavOfClient,
      required})
      : _phoneWidth = phoneWidth,
        _phoneHeight = phoneHeight,
        _hairArtistProvider = hairArtistProvider,
        _isForDisplay = isForDisplay,
        _fontSizeProvider = fontSizeProvider,
        _hairArtistUserProfile = hairArtistUserProfile,
        _hairClientProfileProvider = hairClientProfileProvider,
        _isFavOfClient = isFavOfClient,
        super(key: key);

  final double _phoneWidth;
  final double _phoneHeight;
  final HairArtistProfileProvider? _hairArtistProvider;
  final FontSizeProvider _fontSizeProvider;
  final HairArtistUserProfile _hairArtistUserProfile;
  final bool _isForDisplay;
  final HairClientProfileProvider? _hairClientProfileProvider;
  bool? _isFavOfClient;

  @override
  _HairArtistProfileDisplayState createState() =>
      _HairArtistProfileDisplayState();
}

class _HairArtistProfileDisplayState extends State<HairArtistProfileDisplay> {
  @override
  void initState() {
    if (!widget._isForDisplay) {
      widget._hairArtistProvider!.getUserDataFromBackend();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthenticationProvider>(context);
    /*to ensure when auto logout occurs then we remove this widget the tree*/
    if (!_authProvider.isLoggedIn && widget._isForDisplay) {
      Timer(
        Duration(seconds: 1),
        () {
          Navigator.of(context).pop();
        },
      );
    }
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
                    child: widget._isForDisplay
                        ? TextButton(
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                              size: 30,
                            ),
                            onPressed: () => Navigator.pop(context),
                          )
                        : Text(""),
                  ),
                  actions: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 15, 0),
                      width: 50.0,
                      height: 50.0,
                      child: !widget._isForDisplay
                          ? GalleryPicker()
                          : widget._isFavOfClient!
                              ? TextButton(
                                  child: Icon(
                                    MaterialIcons.remove_circle_outline,
                                    color: Theme.of(context).accentColor,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    widget._hairClientProfileProvider!
                                        .removeHairArtistFavorite(
                                            widget._hairArtistUserProfile.uid);
                                    setState(() {
                                      widget._isFavOfClient = false;
                                    });
                                  })
                              : TextButton(
                                  child: Icon(
                                    MaterialIcons.favorite_border,
                                    color: Theme.of(context).accentColor,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    widget._hairClientProfileProvider!
                                        .addHairArtistFavorite(
                                            widget._hairArtistUserProfile);
                                    setState(() {
                                      widget._isFavOfClient = true;
                                    });
                                  }),
                    ),
                  ],
                  elevation: 0,
                  backgroundColor: Colors.white,
                  expandedHeight: widget._phoneWidth * 0.73,
                  collapsedHeight: widget._phoneHeight * 0.1,
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
                              bottom: widget._phoneHeight * 0.06,
                            ),
                            child: Text(
                              top >= widget._phoneHeight * 0.1 &&
                                      top < widget._phoneHeight * 0.3
                                  ? widget._hairArtistUserProfile.about.name
                                  : "",
                              style: widget._fontSizeProvider.headline2,
                            ),
                          ),
                        ),
                        background: Column(
                          children: [
                            SizedBox(
                              height: widget._phoneHeight * 0.08,
                            ),
                            !widget._isForDisplay
                                ? HairArtistProfilePicIcon(
                                    phoneWidth: widget._phoneWidth,
                                    hairArtistProfileProvider:
                                        widget._hairArtistProvider!,
                                    hairArtistUserProfile:
                                        widget._hairArtistUserProfile,
                                    isForDisplay: widget._isForDisplay,
                                  )
                                : HairArtistProfilePicIcon(
                                    phoneWidth: widget._phoneWidth,
                                    hairArtistUserProfile:
                                        widget._hairArtistUserProfile,
                                    isForDisplay: widget._isForDisplay,
                                  ),
                            Padding(
                              padding: EdgeInsets.all(
                                widget._phoneHeight * 0.015,
                              ),
                              child: Text(
                                widget._hairArtistUserProfile.about.name,
                                style: widget._fontSizeProvider.headline2,
                              ),
                            ),
                            !widget._isForDisplay
                                ? SmallButton(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    child: Text("Edit Profile"),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new EditHairArtistProfileForm(
                                            widget._fontSizeProvider,
                                            widget._hairArtistProvider!,
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
              !widget._isForDisplay
                  ? HairArtistGallery(
                      hairArtistProvider: widget._hairArtistProvider,
                      fontSizeProvider: widget._fontSizeProvider,
                      isForDisplay: widget._isForDisplay,
                      hairArtistUserProfile: widget._hairArtistUserProfile,
                    )
                  : HairArtistGallery(
                      hairArtistUserProfile: widget._hairArtistUserProfile,
                      isForDisplay: widget._isForDisplay,
                      fontSizeProvider: widget._fontSizeProvider,
                    ),
              HairArtistAbout(
                hairArtistUserProfile: widget._hairArtistUserProfile,
                fontSizeProvider: widget._fontSizeProvider,
              ),
              !widget._isForDisplay
                  ? HairArtistReviews(
                      hairArtistUserProfile: widget._hairArtistUserProfile,
                      isForDisplay: widget._isForDisplay,
                    )
                  : HairArtistReviews(
                      hairArtistUserProfile: widget._hairArtistUserProfile,
                      isForDisplay: widget._isForDisplay,
                      hairClientProfileProvider:
                          widget._hairClientProfileProvider!,
                    )
            ],
          ),
        ),
      ),
    );
  }
}
