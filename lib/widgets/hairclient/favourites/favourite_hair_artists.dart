import 'package:flutter/material.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/providers/hair_client_profile_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/widgets/hairclient/favourites/favourite_widget.dart';
import 'package:provider/provider.dart';

class FavouriteHairArtists extends StatefulWidget {
  const FavouriteHairArtists({Key? key}) : super(key: key);

  @override
  _FavouriteHairArtistsState createState() => _FavouriteHairArtistsState();
}

class _FavouriteHairArtistsState extends State<FavouriteHairArtists> {
  @override
  void initState() {
    super.initState();
    Provider.of<HairClientProfileProvider>(context, listen: false)
        .getUserDataFromBackend(
            Provider.of<AuthenticationProvider>(context, listen: false));
  }

  @override
  Widget build(BuildContext context) {
    final _hairClientProfileProvider =
        Provider.of<HairClientProfileProvider>(context);
    final _fontSizeProvider = Provider.of<FontSizeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, //change your color here
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        // backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Favourites",
          style: _fontSizeProvider.headline3,
        ),
      ),
      body: ListView.builder(
        itemCount: _hairClientProfileProvider
            .hairClientProfile.favouriteHairArtists.length,
        itemBuilder: (context, index) {
          return FavouriteWidget(
            listIndex: index,
            hairArtistUserProfile: _hairClientProfileProvider
                .hairClientProfile.favouriteHairArtists[index],
          );
        },
        physics: ScrollPhysics(),
      ),
    );
  }
}
