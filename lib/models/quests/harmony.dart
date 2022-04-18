import '../kingdom.dart';
import 'quest.dart';

class Harmony extends Quest {
  static final Harmony _singleton = Harmony._internal();

  factory Harmony() {
    return _singleton;
  }

  Harmony._internal() : super(reward: 5);

  @override
  int? getPoints(Kingdom kingdom) {
    return kingdom
            .getLands()
            .expand((i) => i)
            .toList()
            .where((land) => land.landType == null)
            .isEmpty
        ? reward
        : 0;
  }
}
