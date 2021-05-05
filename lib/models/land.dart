import 'lacour/lacour.dart';

enum LandType { none, wheat, grassland, forest, lake, swamp, mine, castle }

class Land {
  LandType? landType = LandType.none;
  int crowns = 0;
  bool isMarked = false; //to create properties

  // AoG extension
  int giants = 0;

  // La cour extension
  CourtierType? courtierType;
  bool hasResource = false;

  ///set crowns to 0 and hasGiant to false
  void reset() {
    crowns = 0;
    giants = 0;
    hasResource = false;
  }

  /// count crowns minus the number of giants
  int getCrowns() {
    return crowns - giants;
  }

  Land(this.landType);
}

class Property {
  LandType? landType;
  int crownCount = 0;
  int landCount = 0;

  //AoG
  int giantCount = 0;

  Property(this.landType);
}