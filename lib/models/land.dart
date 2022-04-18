import 'package:flutter/material.dart';

import 'lacour/lacour.dart';

enum LandType { wheat, grassland, forest, lake, swamp, mine, castle }

class Land {
  LandType? landType;
  int crowns;
  bool isMarked = false; //to create properties

  // AoG extension
  int giants;

  // La cour extension
  CourtierType? courtierType;
  bool hasResource;

  Land(
      {this.landType,
      this.crowns = 0,
      this.courtierType,
      this.hasResource = false,
      this.giants = 0});

  Land copyWith(
      {LandType? landType,
      int? crowns,
      CourtierType? courtierType,
      bool? hasResource,
      int? giants}) {
    return Land(
        landType: landType ?? this.landType,
        crowns: crowns ?? this.crowns,
        courtierType: courtierType ?? this.courtierType,
        hasResource: hasResource ?? this.hasResource,
        giants: giants ?? this.giants);
  }

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
}

String getResourceForLandType(LandType? type) {
  switch (type) {
    case LandType.grassland:
      return '🐑';
    case LandType.lake:
      return '🐟';
    case LandType.wheat:
      return '🌾';
    case LandType.forest:
      return '🪵';
    default:
      return '?';
  }
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

