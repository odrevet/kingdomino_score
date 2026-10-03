import '../kingdom.dart';
import '../land.dart' show LandType;
import 'quest.dart';

class LocalBusiness extends Quest {
  static final LocalBusiness _singleton = LocalBusiness._internal();

  factory LocalBusiness(LandType landType) {
    _singleton.landType = landType;
    return _singleton;
  }

  LocalBusiness._internal() : super(reward: 5);

  LandType? landType;

  @override
  List<(int, int)> getPlaces(Kingdom kingdom) {
    final castle = kingdom.findCastle();
    if (castle == null) return [];

    final places = <(int, int)>[];
    for (var dx = -1; dx <= 1; dx++) {
      for (var dy = -1; dy <= 1; dy++) {
        if (dx == 0 && dy == 0) continue;
        final x = castle.$1 + dx;
        final y = castle.$2 + dy;
        if (kingdom.isInBound(x, y) &&
            kingdom.getLand(x, y)?.landType == landType) {
          places.add((x, y));
        }
      }
    }
    return places;
  }
}
