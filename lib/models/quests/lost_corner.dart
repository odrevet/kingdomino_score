import '../kingdom.dart';
import '../land.dart' show LandType;
import 'quest.dart';

class LostCorner extends Quest {
  static final LostCorner _singleton = LostCorner._internal();

  factory LostCorner() {
    return _singleton;
  }

  LostCorner._internal() : super(reward: 20);

  @override
  int getPoints(Kingdom kingdom) {
    int size = kingdom.kingdomSize.size - 1;
    return kingdom.getLand(0, 0)?.landType == LandType.castle ||
            kingdom.getLand(size, 0)?.landType == LandType.castle ||
            kingdom.getLand(0, size)?.landType == LandType.castle ||
            kingdom.getLand(size, size)?.landType == LandType.castle
        ? reward
        : 0;
  }
}
