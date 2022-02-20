import '../kingdom.dart';
import '../land.dart';

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

enum CourtierType {
  farmer,
  banker,
  lumberjack,
  light_archery,
  fisherman,
  heavy_archery,
  shepherdess,
  captain,
  axe_warrior,
  sword_warrior,
  king,
  queen
}

Map<CourtierType, String> courtierPicture = {
  CourtierType.farmer: 'assets/lacour/farmer.png',
  CourtierType.banker: 'assets/lacour/banker.png',
  CourtierType.lumberjack: 'assets/lacour/lumberjack.png',
  CourtierType.light_archery: 'assets/lacour/light_archery.png',
  CourtierType.fisherman: 'assets/lacour/fisherman.png',
  CourtierType.heavy_archery: 'assets/lacour/heavy_archery.png',
  CourtierType.shepherdess: 'assets/lacour/shepherdess.png',
  CourtierType.captain: 'assets/lacour/captain.png',
  CourtierType.axe_warrior: 'assets/lacour/axe_warrior.png',
  CourtierType.sword_warrior: 'assets/lacour/sword_warrior.png',
  CourtierType.king: 'assets/lacour/king.png',
  CourtierType.queen: 'assets/lacour/queen.png',
};

abstract class Courtier {
  int getPoints(Kingdom kingdom, int x, int y);
}
