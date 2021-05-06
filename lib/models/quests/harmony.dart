import '../kingdom.dart';
import 'quest.dart';

class Harmony extends Quest {
  static final Harmony _singleton = Harmony._internal();

  factory Harmony() {
    return _singleton;
  }

  Harmony._internal();

  int? extraPoints = 5;

  int? getPoints(Kingdom kingdom) {
    return kingdom
            .getLands()
            .expand((i) => i)
            .toList()
            .where((land) => land.landType == null)
            .isEmpty
        ? extraPoints
        : 0;
  }
}
