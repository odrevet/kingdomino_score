import '../kingdom.dart';

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

abstract class Courtier
{
  int getPoints(Kingdom kingdom, int x, int y);
}




