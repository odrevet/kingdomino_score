import 'package:kingdomino_score_count/models/lacour/axe_warrior.dart';
import 'package:kingdomino_score_count/models/lacour/banker.dart';
import 'package:kingdomino_score_count/models/lacour/captain.dart';
import 'package:kingdomino_score_count/models/lacour/farmer.dart';
import 'package:kingdomino_score_count/models/lacour/fisherman.dart';
import 'package:kingdomino_score_count/models/lacour/heavy_archery.dart';
import 'package:kingdomino_score_count/models/lacour/king.dart';
import 'package:kingdomino_score_count/models/lacour/light_archery.dart';
import 'package:kingdomino_score_count/models/lacour/lumberjack.dart';
import 'package:kingdomino_score_count/models/lacour/queen.dart';
import 'package:kingdomino_score_count/models/lacour/shepherdess.dart';
import 'package:kingdomino_score_count/models/lacour/sword_warrior.dart';

import '../kingdom.dart';
import '../land.dart';

export 'axe_warrior.dart';
export 'banker.dart';
export 'captain.dart';
export 'farmer.dart';
export 'fisherman.dart';
export 'heavy_archery.dart';
export 'king.dart';
export 'light_archery.dart';
export 'lumberjack.dart';
export 'queen.dart';
export 'shepherdess.dart';
export 'sword_warrior.dart';

const Map<LandType, Map<String, dynamic>> laCourGameSet = {
  LandType.castle: {
    'count': 1, //per player
    'crowns': {'max': 0}
  },
  LandType.wheat: {
    'count': 21 + 5,
    'crowns': {'max': 1, 1: 5 + 3}
  },
  LandType.grassland: {
    'count': 10 + 2 + 2,
    'crowns': {'max': 2, 1: 2 + 1, 2: 2 + 1}
  },
  LandType.forest: {
    'count': 16 + 6,
    'crowns': {'max': 1, 1: 6 + 3}
  },
  LandType.lake: {
    'count': 12 + 6,
    'crowns': {'max': 1, 1: 6 + 3}
  },
  LandType.swamp: {
    'count': 6 + 2 + 2,
    'crowns': {'max': 2, 1: 2 + 1, 2: 2 + 1}
  },
  LandType.mine: {
    'count': 1 + 1 + 3 + 1,
    'crowns': {'max': 3, 1: 1, 2: 3, 3: 1}
  }
};

Map<Type, String> courtierPicture = {
  Farmer: 'assets/lacour/farmer.png',
  Banker: 'assets/lacour/banker.png',
  Lumberjack: 'assets/lacour/lumberjack.png',
  LightArchery: 'assets/lacour/light_archery.png',
  Fisherman: 'assets/lacour/fisherman.png',
  HeavyArchery: 'assets/lacour/heavy_archery.png',
  Shepherdess: 'assets/lacour/shepherdess.png',
  Captain: 'assets/lacour/captain.png',
  AxeWarrior: 'assets/lacour/axe_warrior.png',
  SwordWarrior: 'assets/lacour/sword_warrior.png',
  King: 'assets/lacour/king.png',
  Queen: 'assets/lacour/queen.png',
};

abstract class Courtier {
  bool isWarrior;

  Courtier({this.isWarrior = false});

  int getPoints(Kingdom kingdom, int x, int y);
}
