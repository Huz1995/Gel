import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gel/models/hair_artist_user_profile.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/custom_dialogs.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:gel/providers/hair_client_profile_provider.dart';
import 'package:gel/providers/messages_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/providers/ui_service.dart';
import 'package:gel/widgets/general/small_button.dart';
import 'package:gel/widgets/general_profile/hair_artist_about.dart';
import 'package:gel/widgets/general_profile/hair_artist_gallery.dart';
import 'package:gel/widgets/general_profile/profile_tab_bar.dart';
import 'package:gel/widgets/hairartist/profile/edit_hair_artist_profile_form.dart';
import 'package:gel/widgets/hairartist/profile/gallery_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'hair_artist_profile_pic_icon.dart';
import 'hair_artist_reviews.dart';

class HairArtistProfileDisplay extends StatefulWidget {
  HairArtistProfileDisplay(
      {Key? key,
      HairArtistProfileProvider? hairArtistProfileProvider,
      HairClientProfileProvider? hairClientProfileProvider,
      required HairArtistUserProfile hairArtistUserProfile,
      required FontSizeProvider fontSizeProvider,
      required bool isForDisplay,
      required bool isDisplayForArtist,
      bool? isFavOfClient,
      required})
      : _hairArtistProfileProvider = hairArtistProfileProvider,
        _isForDisplay = isForDisplay,
        _fontSizeProvider = fontSizeProvider,
        _hairArtistUserProfile = hairArtistUserProfile,
        _hairClientProfileProvider = hairClientProfileProvider,
        _isFavOfClient = isFavOfClient,
        _isDisplayForArtist = isDisplayForArtist,
        super(key: key);

  final HairArtistProfileProvider? _hairArtistProfileProvider;
  final FontSizeProvider _fontSizeProvider;
  final HairArtistUserProfile _hairArtistUserProfile;
  final bool _isForDisplay;
  final bool _isDisplayForArtist;
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
      widget._hairArtistProfileProvider!.getUserDataFromBackend();
    }
    super.initState();
  }

  void _launchPhoneURL(String phoneNumber) async {
    String url = 'tel:' + phoneNumber;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _callHairArist() {
    String number = widget._hairArtistUserProfile.about.dialCode +
        widget._hairArtistUserProfile.about.contactNumber;
    if (number != "") {
      _launchPhoneURL(number);
    } else {
      CustomDialogs.showMyDialogOneButton(
        context: context,
        title: Text("No Number Found"),
        body: [Text("The hair artist has not uploaded their number")],
        buttonChild: Text("Back"),
        buttonOnPressed: () {
          Navigator.of(context).pop();
        },
      );
    }
  }

  Widget _favouriteOfClient() {
    if (widget._isFavOfClient!) {
      return TextButton(
          child: Icon(
            MaterialIcons.remove_circle_outline,
            color: Theme.of(context).accentColor,
            size: 30,
          ),
          onPressed: () {
            widget._hairClientProfileProvider!
                .removeHairArtistFavorite(widget._hairArtistUserProfile.uid);
            setState(() {
              widget._isFavOfClient = false;
            });
          });
    }
    return TextButton(
        child: Icon(
          MaterialIcons.favorite_border,
          color: Theme.of(context).accentColor,
          size: 30,
        ),
        onPressed: () {
          widget._hairClientProfileProvider!
              .addHairArtistFavorite(widget._hairArtistUserProfile);
          setState(() {
            widget._isFavOfClient = true;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final _phoneWidth = MediaQuery.of(context).size.width;
    final _phoneHeight = MediaQuery.of(context).size.height;
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
                            onPressed: () async {
                              if (!widget._isDisplayForArtist) {
                                await widget._hairClientProfileProvider!
                                    .getUserDataFromBackend(_authProvider);
                              }
                              Navigator.pop(context);
                            },
                          )
                        : Text(""),
                  ),
                  actions: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 15, 0),
                      width: 50.0,
                      height: 50.0,
                      child: widget._isForDisplay
                          ? !widget._isDisplayForArtist
                              ? _favouriteOfClient()
                              : Text("")
                          : GalleryPicker(),
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
                                  ? widget._hairArtistUserProfile.about.name
                                  : "",
                              style: widget._fontSizeProvider.headline2,
                            ),
                          ),
                        ),
                        background: Column(
                          children: [
                            SizedBox(
                              height: _phoneHeight * 0.08,
                            ),
                            !widget._isForDisplay
                                ? HairArtistProfilePicIcon(
                                    phoneWidth: _phoneWidth,
                                    hairArtistProfileProvider:
                                        widget._hairArtistProfileProvider!,
                                    hairArtistUserProfile:
                                        widget._hairArtistUserProfile,
                                    isForDisplay: widget._isForDisplay,
                                  )
                                : HairArtistProfilePicIcon(
                                    phoneWidth: _phoneWidth,
                                    hairArtistUserProfile:
                                        widget._hairArtistUserProfile,
                                    isForDisplay: widget._isForDisplay,
                                  ),
                            Padding(
                              padding: EdgeInsets.all(
                                _phoneHeight * 0.015,
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
                                            widget._hairArtistProfileProvider!,
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
                                        onPressed: _callHairArist,
                                      ),
                                      !widget._isDisplayForArtist
                                          ? Row(
                                              children: [
                                                SizedBox(width: 10),
                                                SmallButton(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .accentColor,
                                                  child: Text("Message"),
                                                  buttonWidth: 125,
                                                  onPressed: () {
                                                    widget
                                                        ._hairClientProfileProvider!
                                                        .hairClientProfile
                                                        .addArtistUidToMessageList(
                                                            widget
                                                                ._hairArtistUserProfile
                                                                .uid);
                                                    Navigator.of(context).pop();
                                                    widget
                                                        ._hairClientProfileProvider!
                                                        .setHairClientBottomNavBarState(
                                                            1);
                                                  },
                                                )
                                              ],
                                            )
                                          : SizedBox(
                                              height: 0,
                                              width: 0,
                                            ),
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
                      hairArtistProvider: widget._hairArtistProfileProvider,
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
              (!widget._isForDisplay || widget._isDisplayForArtist)
                  ? HairArtistReviews(
                      hairArtistUserProfile: widget._hairArtistUserProfile,
                      isForDisplay: widget._isForDisplay,
                      isDisplayForArtist: widget._isDisplayForArtist,
                    )
                  : HairArtistReviews(
                      hairArtistUserProfile: widget._hairArtistUserProfile,
                      isForDisplay: widget._isForDisplay,
                      hairClientProfileProvider:
                          widget._hairClientProfileProvider!,
                      isDisplayForArtist: widget._isDisplayForArtist,
                    )
            ],
          ),
        ),
      ),
    );
  }
}
