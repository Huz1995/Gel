import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:gel/widgets/general_profile/no_profile_pic_icon.dart';
import 'package:gel/widgets/general_profile/profile_tab_bar.dart';
import 'package:gel/widgets/general/small_button.dart';
import 'package:gel/widgets/hairartistprofile/about.dart';
import 'package:gel/widgets/hairartistprofile/gallery.dart';
import 'package:gel/widgets/hairartistprofile/reviews.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class HairArtistProfileMainPage extends StatefulWidget {
  const HairArtistProfileMainPage({
    Key? key,
  }) : super(key: key);

  @override
  _HairArtistProfileMainPageState createState() =>
      _HairArtistProfileMainPageState();
}

class _HairArtistProfileMainPageState extends State<HairArtistProfileMainPage> {
  final _picker = ImagePicker();
  List<File> _pickedImages = [];

  void _pickImage() async {
    final PickedFile? image =
        await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _pickedImages.add(File(image!.path));
    });
  }

  @override
  Widget build(BuildContext context) {
    final _authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    final _hairArtistProfileProvider =
        Provider.of<HairArtistProfileProvider>(context, listen: false);
    String _emailTextDisplay =
        "@" + _hairArtistProfileProvider.hairArtistProfile.email.split("@")[0];

    final _phoneHeight = MediaQuery.of(context).size.height;
    final _phoneWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 3,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              actions: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 15, 0),
                  width: 50.0,
                  height: 50.0,
                  child: RawMaterialButton(
                    shape: CircleBorder(),
                    elevation: 0.0,
                    child: Icon(
                      Icons.add_a_photo_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                    onPressed: _pickImage,
                  ),
                ),
              ],
              elevation: 0,
              backgroundColor: Colors.white,
              expandedHeight: _phoneHeight * 0.35,
              collapsedHeight: _phoneHeight * 0.1,
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  var top = constraints.biggest.height;
                  return FlexibleSpaceBar(
                    centerTitle: true,
                    title: AnimatedOpacity(
                      opacity: 1,
                      duration: Duration(milliseconds: 1),
                      child: Container(
                        margin: EdgeInsets.only(
                          bottom: _phoneHeight * 0.06,
                        ),
                        child: Text(
                          top >= _phoneHeight * 0.1 && top < _phoneHeight * 0.3
                              ? _emailTextDisplay
                              : "",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                    ),
                    background: Column(
                      children: [
                        SizedBox(
                          height: _phoneHeight * 0.08,
                        ),
                        NoProfilePicIcon(phoneWidth: _phoneWidth),
                        Padding(
                          padding: EdgeInsets.all(
                            _phoneHeight * 0.015,
                          ),
                          child: Text(
                            _emailTextDisplay,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                        SmallButton(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text("          Edit Profile         "),
                          onPressed: () => print(_authProvider.idToken),
                        )
                      ],
                    ),
                  );
                },
              ),
              pinned: true,
              bottom: ProfileTabBar(),
            ),
            SliverFillRemaining(
              child: TabBarView(
                children: [
                  Gallery(pickedImages: _pickedImages),
                  About(),
                  Reviews(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
