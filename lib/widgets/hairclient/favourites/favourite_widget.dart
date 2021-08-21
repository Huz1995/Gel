import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gel/models/hair_artist_user_profile.dart';
import 'package:gel/providers/hair_artist_profile_provider.dart';
import 'package:gel/providers/hair_client_profile_provider.dart';
import 'package:gel/providers/messages_provider_client.dart';
import 'package:gel/providers/text_size_provider.dart';
import 'package:gel/providers/ui_service.dart';
import 'package:gel/widgets/general_profile/hair_artist_profile_display.dart';
import 'package:provider/provider.dart';

class FavouriteWidget extends StatelessWidget {
  late int? listIndex;
  late HairArtistUserProfile? hairArtistUserProfile;

  FavouriteWidget({this.listIndex, this.hairArtistUserProfile});

  Widget build(BuildContext context) {
    final _fontSizeProvider = Provider.of<FontSizeProvider>(context);
    final _hairClientProfileProvider =
        Provider.of<HairClientProfileProvider>(context);
    final _messageProviderClient =
        Provider.of<MessagesProviderClient>(context, listen: false);
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => HairArtistProfileDisplay(
            hairArtistUserProfile: hairArtistUserProfile!,
            hairClientProfileProvider: _hairClientProfileProvider,
            fontSizeProvider: _fontSizeProvider,
            isFavOfClient: HairClientProfileProvider.isAFavorite(
                _hairClientProfileProvider.hairClientProfile,
                hairArtistUserProfile!),
            isForDisplay: true,
            isDisplayForArtist: false,
            messageProviderClient: _messageProviderClient,
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    UIService.getProfilePicIcon(
                        hasProfilePic:
                            (hairArtistUserProfile!.profilePhotoUrl != null),
                        context: context,
                        url: hairArtistUserProfile!.profilePhotoUrl,
                        radius: 30),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              hairArtistUserProfile!.about.name,
                              style: _fontSizeProvider.headline4,
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            // Text(
                            //   widget.messageText,
                            //   style: TextStyle(
                            //       fontSize: 13,
                            //       color: Colors.grey.shade600,
                            //       fontWeight: widget.isMessageRead
                            //           ? FontWeight.bold
                            //           : FontWeight.normal),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Text(
              //   widget.time,
              //   style: TextStyle(
              //       fontSize: 12,
              //       fontWeight: widget.isMessageRead
              //           ? FontWeight.bold
              //           : FontWeight.normal),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   final _fontSizeProvider = Provider.of<FontSizeProvider>(context);
  //   final _hairClientProfileProvider =
  //       Provider.of<HairClientProfileProvider>(context);

  //   return Column(
  //     children: [
  //       Container(
  //         padding: const EdgeInsets.all(10.0),
  //         height: 215,
  //         child: Card(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(30.0),
  //           ),
  //           color: listIndex! % 2 == 0
  //               ? Theme.of(context).primaryColor.withOpacity(0.05)
  //               : Theme.of(context).accentColor.withOpacity(0.05),
  //           elevation: 20,
  //           child: TextButton(
  //             onPressed: () => Navigator.of(context).push(
  //               MaterialPageRoute(
  //                 builder: (context) => HairArtistProfileDisplay(
  //                   hairArtistUserProfile: hairArtistUserProfile!,
  //                   hairClientProfileProvider: _hairClientProfileProvider,
  //                   fontSizeProvider: _fontSizeProvider,
  //                   isFavOfClient: HairClientProfileProvider.isAFavorite(
  //                       _hairClientProfileProvider.hairClientProfile,
  //                       hairArtistUserProfile!),
  //                   isForDisplay: true,
  //                   isDisplayForArtist: false,
  //                 ),
  //               ),
  //             ),
  //             child: Row(
  //               children: [
  //                 Container(
  //                   padding: EdgeInsets.all(16),
  //                   margin: EdgeInsets.fromLTRB(4, 4, 0, 0),
  //                   child: Column(
  //                     children: [
  //                       UIService.getProfilePicIcon(
  //                           hasProfilePic:
  //                               (hairArtistUserProfile!.profilePhotoUrl !=
  //                                   null),
  //                           context: context,
  //                           url: hairArtistUserProfile!.profilePhotoUrl),
  //                       SizedBox(
  //                         height: 10,
  //                       ),
  //                       Text(
  //                         hairArtistUserProfile!.about.name,
  //                         style: _fontSizeProvider.headline4,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
