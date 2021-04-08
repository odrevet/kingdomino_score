import '../kingdom.dart';
import '../quest.dart';

class LostCorner extends Quest {
  final int extraPoints = 20;

  LostCorner();

  int getPoints(Kingdom kingdom) {
    int size = kingdom.size - 1;
    return kingdom.getLand(0, 0).landType == LandType.castle ||
            kingdom.getLand(size, 0).landType == LandType.castle ||
            kingdom.getLand(0, size).landType == LandType.castle ||
            kingdom.getLand(size, size).landType == LandType.castle
        ? extraPoints
        : 0;
  }
}
