import 'package:flutter/material.dart';

import 'lacour/lacour.dart';

enum LandType { wheat, grassland, forest, lake, swamp, mine, castle }

class Land {
  LandType? landType;
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
    courtierType = null;
  }

  /// count crowns minus the number of giants
  int getCrowns() {
    return crowns - giants;
  }

  Land([this.landType]);
}

Color getColorForLandType(LandType? type) {
  Color color;
  switch (type) {
    case null:
      color = Colors.blueGrey.shade400;
      break;
    case LandType.wheat:
      color = Colors.yellow.shade600;
      break;
    case LandType.grassland:
      color = Colors.lightGreen;
      break;
    case LandType.forest:
      color = Colors.green.shade800;
      break;
    case LandType.lake:
      color = Colors.blue.shade400;
      break;
    case LandType.mine:
      color = Colors.brown.shade800;
      break;
    case LandType.swamp:
      color = Colors.grey.shade400;
      break;
    case LandType.castle:
      color = Colors.white;
      break;
    default:
      color = Colors.red;
  }

  return color;
}

Color getResourceColorForLandType(LandType? type) {
  Color color;
  switch (type) {
    case LandType.wheat:
      color = Colors.yellow.shade800;
      break;
    case LandType.grassland:
      color = Colors.green;
      break;
    case LandType.forest:
      color = Colors.green.shade900;
      break;
    case LandType.lake:
      color = Colors.blue.shade600;
      break;
    default:
      color = Colors.red;
  }

  return color;
}
