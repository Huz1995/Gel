import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gel/models/hair_artist_user_profile.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HairArtistAbout extends StatelessWidget {
  const HairArtistAbout(
      {Key? key,
      required HairArtistUserProfile hairArtistUserProfile,
      required FontSizeProvider fontSizeProvider,
      required})
      : _hairArtistUserProfile = hairArtistUserProfile,
        _fontSizeProvider = fontSizeProvider,
        super(key: key);
  final HairArtistUserProfile _hairArtistUserProfile;
  final _fontSizeProvider;
  @override
  Widget build(BuildContext context) {
    void _launchURL(String url) async => await canLaunch(url)
        ? await launch(url)
        : throw 'Could not launch $url';

    return Scaffold(
      body: Container(
        child: Center(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 40),
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
              ),
              Container(
                child: Text(
                  "About",
                  style: _fontSizeProvider.headline3,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              _hairArtistUserProfile.about.description != ""
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_hairArtistUserProfile.about.description),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    )
                  : SizedBox(
                      height: 0,
                      width: 0,
                    ),
              _hairArtistUserProfile.about.chatiness != ""
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_hairArtistUserProfile.about.chatiness),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    )
                  : SizedBox(
                      height: 0,
                      width: 0,
                    ),
              _hairArtistUserProfile.about.instaUrl != ""
                  ? Row(
                      children: [
                        Text(
                          "Instagram",
                          style: _fontSizeProvider.headline4,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints.tightFor(width: 37),
                          child: FloatingActionButton(
                            heroTag: "instagram",
                            elevation: 0,
                            backgroundColor:
                                Theme.of(context).cardColor.withOpacity(0.2),
                            child: Container(
                              margin: EdgeInsets.fromLTRB(1, 0, 0, 3),
                              child: Icon(
                                AntDesign.instagram,
                                color: Colors.black,
                                size: 26,
                              ),
                            ),
                            onPressed: () => {
                              _launchURL(_hairArtistUserProfile.about.instaUrl),
                            },
                          ),
                        ),
                      ],
                    )
                  : SizedBox(
                      height: 0,
                      width: 0,
                    ),
              Divider(
                height: 25,
                thickness: 3,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Work Related Stuff",
                style: _fontSizeProvider.headline3,
              ),
              SizedBox(
                height: 30,
              ),
              _hairArtistUserProfile.about.workingArrangement != ""
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Working Arrangements: ",
                          style: _fontSizeProvider.headline4,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(_hairArtistUserProfile.about.workingArrangement),
                        Divider(
                          thickness: 2,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    )
                  : Text(""),
              _hairArtistUserProfile.about.previousWorkExperience != ""
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Previous Work Experience: ",
                          style: _fontSizeProvider.headline4,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(_hairArtistUserProfile
                            .about.previousWorkExperience),
                        Divider(
                          thickness: 2,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    )
                  : Text(""),
              _hairArtistUserProfile.about.hairTypes != ""
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hair Type Specialies: ",
                          style: _fontSizeProvider.headline4,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(_hairArtistUserProfile.about.hairTypes),
                        Divider(
                          thickness: 2,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    )
                  : Text(""),
              _hairArtistUserProfile.about.hairServCost != ""
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hair Services and Prices ",
                          style: _fontSizeProvider.headline4,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(_hairArtistUserProfile.about.hairServCost),
                        Divider(
                          thickness: 2,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    )
                  : Text(""),
            ],
          ),
        ),
      ),
    );
  }
}
