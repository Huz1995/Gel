import 'package:flutter/material.dart';
import 'package:gel/providers/hair_client_profile_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/widgets/hairclient/favourites/favourite_widget.dart';
import 'package:provider/provider.dart';

class FavouriteHairArtists extends StatelessWidget {
  const FavouriteHairArtists({Key? key}) : super(key: key);

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