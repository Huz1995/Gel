import 'package:gel/models/hair_artist_user_profile.dart';

class HairClientUserProfile {
  String _uid;
  String _email;
  bool _isHairArtist;
  String? _profilePhotoUrl;
  String _name;
  List<HairArtistUserProfile> favouriteHairArtists;

  HairClientUserProfile(
    this._uid,
    this._email,
    this._isHairArtist,
    this._profilePhotoUrl,
    this._name,
    this.favouriteHairArtists,
  );

  String get uid {
    return _uid;
  }

  String get email {
    return _email;
  }

  bool get isHairArtist {
    return _isHairArtist;
  }

  String? get profilePhotoUrl {
    return _profilePhotoUrl;
  }

  String get name {
    return _name;
  }

  List<HairArtistUserProfile> get favourites {
    return favouriteHairArtists;
  }

  void addFavourite(HairArtistUserProfile hairArtist) {
    favouriteHairArtists.add(hairArtist);
  }

  void removeFromFavourite(String artistUID) {
    favouriteHairArtists
        .removeWhere((hairArtist) => hairArtist.uid == artistUID);
  }

  void setName(String name) {
    this._name = name;
  }

  void deleteProfilePhoto() {
    this._profilePhotoUrl = null;
  }

  void addProfilePictureUrl(String url) {
    this._profilePhotoUrl = url;
  }
}
