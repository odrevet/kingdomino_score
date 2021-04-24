import 'picture.dart' show compareRGB;

enum LandType { none, wheat, grassland, forest, lake, swamp, mine, castle }

LandType? getLandtypeFromRGB(List<int> rgb)
{
  LandType? res;
  landRGB.forEach((key, value) {
    if (compareRGB(rgb, value)) {
      res = key;
    }
  });
  return res;
}

Map<LandType, List<int>> landRGB = {
  LandType.swamp: [115, 115, 115],
  LandType.lake: [20, 20, 200],
  LandType.wheat: [250, 210, 20],       //OK
  LandType.mine: [90, 100, 42],
  LandType.forest: [200, 20, 20],
  LandType.grassland: [200, 42, 42],
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