import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _hairArtistProvider = Provider.of<HairArtistProfileProvider>(context);
    final _fontSizeProvider = Provider.of<FontSizeProvider>(context);

    final _about = _hairArtistProvider.hairArtistProfile.about!;

    void _launchURL(String url) async => await canLaunch(url)
        ? await launch(url)
        : throw 'Could not launch $url';

    return Container(
      child: Center(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 40),
          children: [
            SizedBox(
              height: 230,
            ),
            Container(
              child: Text(
                "About",
                style: _fontSizeProvider.headline3,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            _about.description != "" ? Text(_about.description) : Text(""),
            SizedBox(
              height: 10,
            ),
            _about.chatiness != "" ? Text(_about.chatiness) : Text(""),
            SizedBox(
              height: 10,
            ),
            _about.instaUrl != ""
                ? Row(
                    children: [
                      Text(
                        "Instagram",
                        style: _fontSizeProvider.headline4,
                      ),
                      SizedBox(
                        width: 215,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints.tightFor(width: 40),
                        child: FloatingActionButton(
                          heroTag: "instagram",
                          elevation: 0,
                          backgroundColor:
                              Theme.of(context).cardColor.withOpacity(0.3),
                          child: Icon(AntDesign.instagram, color: Colors.black),
                          onPressed: () => {
                            _launchURL(_about.instaUrl),
                          },
                        ),
                      ),
                    ],
                  )
                : Text(""),
            SizedBox(
              height: 10,
            ),
            Divider(
              height: 25,
              thickness: 5,
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
            _about.workingArrangement != ""
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
                      Text(_about.workingArrangement),
                      Divider(
                        thickness: 2,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  )
                : Text(""),
            _about.previousWorkExperience != ""
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
                      Text(_about.previousWorkExperience),
                      Divider(
                        thickness: 2,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  )
                : Text(""),
            _about.hairTypes != ""
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
                      Text(_about.hairTypes),
                      Divider(
                        thickness: 2,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  )
                : Text(""),
            _about.shortHairServCost != ""
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Short Hair Services and Prices ",
                        style: _fontSizeProvider.headline4,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(_about.shortHairServCost),
                      Divider(
                        thickness: 2,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  )
                : Text(""),
            _about.longHairServCost != ""
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Short Hair Services and Prices ",
                        style: _fontSizeProvider.headline4,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(_about.longHairServCost),
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
    );
  }
}
