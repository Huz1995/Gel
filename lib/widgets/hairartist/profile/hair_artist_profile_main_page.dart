import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gel/providers/custom_dialogs.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/widgets/hairartist/profile/gallery_picker.dart';
import 'package:gel/widgets/hairartist/profile/profile_pic_icon.dart';
import 'package:gel/widgets/general_profile/profile_tab_bar.dart';
import 'package:gel/widgets/general/small_button.dart';
import 'package:gel/widgets/hairartist/profile/about.dart';
import 'package:gel/widgets/hairartist/profile/edit_hair_artist_profile_form.dart';
import 'package:gel/widgets/hairartist/profile/gallery.dart';
import 'package:gel/widgets/hairartist/profile/reviews.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class HairArtistProfileMainPage extends StatefulWidget {
  @override
  _HairArtistProfileMainPageState createState() =>
      _HairArtistProfileMainPageState();
}

class _HairArtistProfileMainPageState extends State<HairArtistProfileMainPage> {
  late StreamSubscription<Position> _positionStream;

  @override
  void initState() {
    super.initState();
    print("dffd");

    Geolocator.checkPermission().then(
      (value) async {
        if (value == LocationPermission.denied ||
            value == LocationPermission.deniedForever) {
          Geolocator.requestPermission().then(
            (value) async {
              if (value == LocationPermission.denied ||
                  value == LocationPermission.deniedForever) {
                CustomDialogs.showMyDialogOneButton(
                  context,
                  Text("Warning"),
                  [
                    Text(
                        "In order for people in you area to discover your services, you will need to add location services, in settings you can update your location services"),
                  ],
                  Text("Ok"),
                  () {
                    Navigator.of(context).pop();
                  },
                );
              } else {
                print(await Geolocator.getLastKnownPosition());
              }
            },
          );
        } else {
          _positionStream = Geolocator.getPositionStream(distanceFilter: 3)
              .listen((position) {
            Provider.of<HairArtistProfileProvider>(context, listen: false)
                .updateHairArtistLocation(
              position.latitude,
              position.longitude,
            );
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _positionStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _fontSizeProvider =
        Provider.of<FontSizeProvider>(context, listen: false);
    final _hairArtistProvider = Provider.of<HairArtistProfileProvider>(context);

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
                                  ? _hairArtistProvider
                                      .hairArtistProfile.about.name
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
                                _hairArtistProvider
                                    .hairArtistProfile.about.name,
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
