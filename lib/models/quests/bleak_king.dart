import '../kingdom.dart';
import '../land.dart' show LandType;
import 'quest.dart';

/// crown covered with giant count as no crown
/// properties must be `at least` of 5 lands, as stated in the french booklet
/// see https://boardgamegeek.com/thread/2032948/bleak-king-aka-poor-mans-bonus-quest-confusion
class BleakKing extends Quest {
  static final BleakKing _singleton = BleakKing._internal();

  factory BleakKing() {
    return _singleton;
  }

  BleakKing._internal() : super(reward: 10);

  @override
  int getPoints(Kingdom kingdom) {
    var properties = kingdom.getProperties();
    int count = properties
        .where(
          (property) =>
              (property.landType == LandType.wheat ||
                  property.landType == LandType.forest ||
                  property.landType == LandType.grassland ||
                  property.landType == LandType.lake) &&
              property.crownCount == 0 &&
              property.landCount >= 5,
        )
        .length;

    return reward * count;
  }
}
