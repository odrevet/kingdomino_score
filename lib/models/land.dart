import 'package:flutter/material.dart';

import 'extensions/lacour/lacour.dart';

enum LandType { wheat, grassland, forest, lake, swamp, mine, castle, empty }

class Land {
  LandType landType;
  int crowns;
  bool isMarked = false; //to create properties

  // AoG extension
  int giants;

  // La cour extension
  Courtier? courtier;
  bool hasResource;

  Land({
    this.landType = LandType.empty,
    this.crowns = 0,
    this.courtier,
    this.hasResource = false,
    this.giants = 0,
  });

  Land copyWith({
    LandType? landType,
    int? crowns,
    Courtier? courtier,
    bool? hasResource,
    int? giants,
  }) {
    return Land(
      landType: landType ?? this.landType,
      crowns: crowns ?? this.crowns,
      courtier: courtier ?? this.courtier,
      hasResource: hasResource ?? this.hasResource,
      giants: giants ?? this.giants,
    );
  }

  ///set crowns to 0 and hasGiant to false
  void reset() {
    crowns = 0;
    giants = 0;
    hasResource = false;
    courtier = null;
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
    case LandType.empty:
      color = Colors.transparent.withValues(alpha: 0.8);
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
