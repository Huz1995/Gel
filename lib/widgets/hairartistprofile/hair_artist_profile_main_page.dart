import 'package:flutter/material.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/widgets/general/small_button.dart';
import 'package:gel/widgets/hairartistprofile/about.dart';
import 'package:gel/widgets/hairartistprofile/gallery.dart';
import 'package:gel/widgets/hairartistprofile/reviews.dart';
import 'package:provider/provider.dart';

class HairArtistProfileMainPage extends StatelessWidget {
  const HairArtistProfileMainPage({
    Key? key,
  }) : super(key: key);

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
                    onPressed: () {},
                  ),
                ),
              ],
              elevation: 0,
              backgroundColor: Colors.white,
              expandedHeight: _phoneHeight * 0.38,
              collapsedHeight: _phoneHeight * 0.1,
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  var top = constraints.biggest.height;
                  return FlexibleSpaceBar(
                    centerTitle: true,
                    title: AnimatedOpacity(
                      opacity: 1,
                      duration: Duration(milliseconds: 10),
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
                          height: _phoneHeight * 0.1,
                        ),
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: _phoneWidth / 10,
                              backgroundColor:
                                  Theme.of(context).cardColor.withOpacity(0.3),
                            ),
                            Positioned(
                              left: _phoneWidth * 0.060,
                              bottom: _phoneWidth * 0.060,
                              //bottom: _phoneWidth / 4,
                              child: Icon(
                                Icons.person,
                                size: 35,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(
                            _phoneHeight * 0.025,
                          ),
                          child: Text(
                            _emailTextDisplay,
                            style: Provider.of<FontSizeProvider>(context)
                                .headline2,
                          ),
                        ),
                        SizedBox(
                          height: _phoneHeight * 0.01,
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
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(30),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: Colors.black.withOpacity(0.4),
                        width: 1,
                      ),
                    ),
                  ),
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Theme.of(context).primaryColor,
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Colors.black.withOpacity(0.5),
                    tabs: [
                      Tab(
                        icon: Icon(
                          Icons.photo_album_outlined,
                          size: 35,
                        ),
                      ),
                      Tab(
                        icon: Icon(
                          Icons.info_outline,
                          size: 35,
                        ),
                      ),
                      Tab(
                        icon: Icon(
                          Icons.rate_review_outlined,
                          size: 35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              child: TabBarView(
                children: [
                  Gallery(),
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
