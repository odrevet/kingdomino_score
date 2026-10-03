import 'package:kingdomino_score_count/models/kingdom_size.dart';

import '../kingdom.dart';
import '../land.dart' show LandType;
import 'quest.dart';

class MiddleKingdom extends Quest {
  static final MiddleKingdom _singleton = MiddleKingdom._internal();

  factory MiddleKingdom() {
    return _singleton;
  }

  MiddleKingdom._internal() : super(reward: 10);

  @override
  List<(int, int)> getPlaces(Kingdom kingdom) {
    final center = kingdom.kingdomSize == KingdomSize.small ? 2 : 3;
    return kingdom.getLand(center, center)?.landType == LandType.castle
        ? [(center, center)]
        : [];
  }
}
