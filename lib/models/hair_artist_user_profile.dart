class HairArtistAboutInfo {
  String? name;
  String? contactNumber;
  String? instaUrl;
  String? description;
  String? chatiness;
  String? workingArrangement;
  String? previousWorkExperience;
  String? hairTypes;
  String? shortHairServCost;
  String? longHairServCost;

  HairArtistAboutInfo(
    this.name,
    this.contactNumber,
    this.instaUrl,
    this.description,
    this.chatiness,
    this.workingArrangement,
    this.previousWorkExperience,
    this.hairTypes,
    this.shortHairServCost,
    this.longHairServCost,
  );

  Map<String, String> toObject() {
    return {
      'name': name!,
      'contactNumber': contactNumber!,
      'instaUrl': instaUrl!,
      'description': description!,
      'chatiness': chatiness!,
      'workingArrangement': workingArrangement!,
      'previousWorkExperience': previousWorkExperience!,
      'hairTypes': hairTypes!,
      'shortHairServCost': shortHairServCost!,
      'longHairServCost': longHairServCost!,
    };
  }

  void printAbout() {
    print(name);
    print(contactNumber);
    print(instaUrl);
    print(description);
    print(chatiness);
    print(workingArrangement);
    print(previousWorkExperience);
    print(hairTypes);
    print(shortHairServCost);
    print(longHairServCost);
  }
}

class HairArtistUserProfile {
  String _uid;
  String _email;
  bool _isHairArtist;
  List<String> _photoUrls;
  String? _profilePhotoUrl;
  HairArtistAboutInfo? _about;

  HairArtistUserProfile(
    this._uid,
    this._email,
    this._isHairArtist,
    this._photoUrls,
    this._profilePhotoUrl,
    this._about,
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

  List<String> get photoUrls {
    return _photoUrls;
  }

  String? get profilePhotoUrl {
    return _profilePhotoUrl;
  }

  HairArtistAboutInfo? get about {
    return _about;
  }

  /*this adds a photo url to the array*/
  void addPhotoUrl(String url) {
    this._photoUrls.insert(0, url);
  }

  void addProfilePictureUrl(String url) {
    this._profilePhotoUrl = url;
  }
}
