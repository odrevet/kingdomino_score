import 'package:flutter/material.dart';

import 'extensions/age_of_giants.dart';
import 'extensions/extension.dart';
import 'extensions/lacour/lacour.dart';
import 'land.dart';

const Map<LandType, Map<String, dynamic>> gameSet = {
  LandType.castle: {
    'count': 1, //per player
    'crowns': {'max': 0}
  },
  LandType.wheat: {
    'count': 21 + 5,
    'crowns': {'max': 1, 1: 5}
  },
  LandType.grassland: {
    'count': 10 + 2 + 2,
    'crowns': {'max': 2, 1: 2, 2: 2}
  },
  LandType.forest: {
    'count': 16 + 6,
    'crowns': {'max': 1, 1: 6}
  },
  LandType.lake: {
    'count': 12 + 6,
    'crowns': {'max': 1, 1: 6}
  },
  LandType.swamp: {
    'count': 6 + 2 + 2,
    'crowns': {'max': 2, 1: 2, 2: 2}
  },
  LandType.mine: {
    'count': 1 + 1 + 3 + 1,
    'crowns': {'max': 3, 1: 1, 2: 3, 3: 1}
  }
};

enum KingColor {
  pink,
  yellow,
  green,
  blue,
  brown;

  MaterialColor get color {
    switch (this) {
      case KingColor.pink:
        return Colors.pink;
      case KingColor.yellow:
        return Colors.yellow;
      case KingColor.green:
        return Colors.green;
      case KingColor.blue:
        return Colors.blue;
      case KingColor.brown:
        return Colors.brown;
    }
  }
}

Map<LandType, Map<String, dynamic>> getGameSet(extension) {
  if (extension == Extension.ageOfGiants) {
    return gameAogSet;
  } else if (extension == Extension.laCour) {
    return laCourGameSet;
  } else {
    return gameSet;
  }
}
