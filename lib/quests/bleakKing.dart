import '../kingdom.dart';
import '../quest.dart';

/// crown covered with giant count as no crown
/// properties must be `at least` of 5 lands, as stated in the french booklet
/// see https://boardgamegeek.com/thread/2032948/bleak-king-aka-poor-mans-bonus-quest-confusion
class BleakKing extends Quest {
  int extraPoints = 10;

  BleakKing();

  int getPoints(Kingdom kingdom) {
    var properties = kingdom.getProperties();
    int count = properties
        .where((property) =>
    (property.landType == LandType.wheat ||
        property.landType == LandType.forest ||
        property.landType == LandType.grassland ||
        property.landType == LandType.lake) &&
        property.crownCount == 0 &&
        property.landCount >= 5)
        .length;

    return extraPoints * count;
  }
}