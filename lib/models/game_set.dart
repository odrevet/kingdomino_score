import 'package:flutter/material.dart';

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

enum Player {
  pink,
  yellow,
  green,
  blue,
  brown;

  String get displayName {
    switch (this) {
      case Player.pink:
        return 'Pink';
      case Player.yellow:
        return 'Yellow';
      case Player.green:
        return 'Green';
      case Player.blue:
        return 'Blue';
      case Player.brown:
        return 'Brown';
    }
  }

  MaterialColor get color {
    switch (this) {
      case Player.pink:
        return Colors.pink;
      case Player.yellow:
        return Colors.yellow;
      case Player.green:
        return Colors.green;
      case Player.blue:
        return Colors.blue;
      case Player.brown:
        return Colors.brown;
    }
  }
}
