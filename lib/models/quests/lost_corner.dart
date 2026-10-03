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
  List<(int, int)> getPlaces(Kingdom kingdom) {
    final last = kingdom.kingdomSize.size - 1;
    for (final corner in [(0, 0), (last, 0), (0, last), (last, last)]) {
      if (kingdom.getLand(corner.$1, corner.$2)?.landType == LandType.castle) {
        return [corner];
      }
    }
    return [];
  }
}
