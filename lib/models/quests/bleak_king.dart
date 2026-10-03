import '../kingdom.dart';
import '../land.dart' show LandType;
import 'quest.dart';

class BleakKing extends Quest {
  static final BleakKing _singleton = BleakKing._internal();

  factory BleakKing() {
    return _singleton;
  }

  BleakKing._internal() : super(reward: 10);

  @override
  List<(int, int)> getPlaces(Kingdom kingdom) {
    return [
      for (final property in kingdom.getProperties())
        if ((property.landType == LandType.wheat ||
                property.landType == LandType.forest ||
                property.landType == LandType.grassland ||
                property.landType == LandType.lake) &&
            property.crownCount == 0 &&
            property.landCount >= 5)
          property.cells.first,
    ];
  }
}
