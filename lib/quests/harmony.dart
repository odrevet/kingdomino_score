import '../kingdom.dart';
import '../quest.dart';

class Harmony extends Quest {
  int extraPoints = 5;

  int getPoints(Kingdom kingdom) {
    return kingdom
            .getLands()
            .expand((i) => i)
            .toList()
            .where((land) => land.landType == LandType.none)
            .isEmpty
        ? extraPoints
        : 0;
  }
}
