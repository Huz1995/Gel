import 'package:flutter/material.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/widgets/general/small_button.dart';
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
              backgroundColor: Colors.white,
              expandedHeight: _phoneHeight * 0.3,
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
                            top >= _phoneHeight * 0.1 &&
                                    top < _phoneHeight * 0.3
                                ? _emailTextDisplay
                                : "",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                      ),
                      background: Column(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          Stack(
                            children: [
                              Container(
                                width: _phoneWidth / 5,
                                height: _phoneWidth / 5,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .cardColor
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      _phoneWidth / 5,
                                    ),
                                  ),
                                ),
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
                              _phoneWidth * 0.04,
                            ),
                            child: Text(
                              _emailTextDisplay,
                              style: Provider.of<FontSizeProvider>(context)
                                  .headline2,
                            ),
                          ),
                          SmallButton(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text("         Edit Profile        "),
                            onPressed: () => print(_authProvider.idToken),
                          )
                        ],
                      ));
                },
              ),
              pinned: true,
              bottom: TabBar(
                tabs: [
                  Tab(
                    icon: Icon(
                      Icons.photo_album,
                      color: Colors.black,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.info,
                      color: Colors.black,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.rate_review,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SliverFillRemaining(
              child: TabBarView(
                children: [
                  Icon(Icons.directions_car),
                  Icon(Icons.directions_transit),
                  Icon(Icons.directions_bike),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
