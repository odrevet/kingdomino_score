enum LandType { none, wheat, grassland, forest, lake, swamp, mine, castle }

class Land {
  LandType? landType = LandType.none;
  int crowns = 0;
  bool isMarked = false; //to create properties
  int giants = 0; //AoG extension

  ///set crowns to 0 and hasGiant to false
  void reset() {
    crowns = 0;
    giants = 0;
  }

  /// count crowns minus the number of giants
  int getCrowns() {
    return crowns - giants;
  }

  Land(this.landType);
}