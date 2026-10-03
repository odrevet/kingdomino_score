import 'package:kingdomino_score_count/models/land.dart';

import '../kingdom.dart';
import 'quest.dart';

class Harmony extends Quest {
  static final Harmony _singleton = Harmony._internal();

  factory Harmony() {
    return _singleton;
  }

  Harmony._internal() : super(reward: 5);

  @override
  List<(int, int)> getPlaces(Kingdom kingdom) {
    final hasEmptyLand = kingdom
        .getLands()
        .expand((i) => i)
        .any((land) => land.landType == LandType.empty);
    return hasEmptyLand ? [] : [kingdom.findCastle() ?? (0, 0)];
  }
}
