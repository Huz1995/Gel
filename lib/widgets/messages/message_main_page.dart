import 'package:flutter/material.dart';
import 'package:gel/providers/hair_client_profile_provider.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/providers/ui_service.dart';
import 'package:gel/widgets/hairclient/favourites/favourite_widget.dart';
import 'package:provider/provider.dart';

class MessagesMainPage extends StatelessWidget {
  late bool? isForHairClient;

  MessagesMainPage({
    this.isForHairClient,
  });

  @override
  Widget build(BuildContext context) {
    if (isForHairClient!) {
      final _hairClientProfileProvider =
          Provider.of<HairClientProfileProvider>(context);
      final _fontSizeProvider = Provider.of<FontSizeProvider>(context);
      return Scaffold(
        appBar: UIService.generalAppBar(context, "Messages"),
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

    return Scaffold(
      appBar: UIService.generalAppBar(context, "Messages"),
      body: Center(
        child: Text("For Artist"),
      ),
    );
  }
}
