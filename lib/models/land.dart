enum LandType { none, wheat, grassland, forest, lake, swamp, mine, castle }

Map<LandType, List<int>> landRGB = {
  LandType.none: [115, 115, 115],
  LandType.swamp: [150, 125, 95],
  LandType.lake: [85, 175, 220],
  LandType.wheat: [220, 200, 70],
  LandType.mine: [120, 105, 105],
  LandType.forest: [110, 120, 100],
  LandType.grassland: [145, 185, 90],
};

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