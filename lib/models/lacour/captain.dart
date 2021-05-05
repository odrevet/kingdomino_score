import '../kingdom.dart';
import '../land.dart';
import 'lacour.dart';

class Captain extends Courtier {
  static final Captain _singleton = Captain._internal();

  factory Captain() {
    return _singleton;
  }

  Captain._internal();

  bool _checkLand(Land land) {
    return [
      CourtierType.axe_warrior,
      CourtierType.heavy_archery,
      CourtierType.light_archery,
      CourtierType.sword_warrior
    ].contains(land.courtierType);
  }

  @override
  int getPoints(Kingdom kingdom, int x, int y) {
    int points = 1;

    if (_checkLand(kingdom.getLand(x - 1, y - 1))) {
      points += 3;
    }

    if (_checkLand(kingdom.getLand(x - 1, y))) {
      points += 3;
    }

    if (_checkLand(kingdom.getLand(x - 1, y + 1))) {
      points += 3;
    }

    if (_checkLand(kingdom.getLand(x, y - 1))) {
      points += 3;
    }

    if (_checkLand(kingdom.getLand(x, y + 1))) {
      points += 3;
    }

    if (_checkLand(kingdom.getLand(x + 1, y - 1))) {
      points += 3;
    }

    if (_checkLand(kingdom.getLand(x + 1, y))) {
      points += 3;
    }

    if (_checkLand(kingdom.getLand(x + 1, y + 1))) {
      points += 3;
    }

    return points;
  }
}
