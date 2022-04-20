import '../../kingdom.dart';
import '../../land.dart';
import 'lacour.dart';

class Queen extends Courtier {
  static final Queen _singleton = Queen._internal();

  factory Queen() {
    return _singleton;
  }

  Queen._internal();

  bool _checkLand(Land land) {
    return land.courtier != null;
  }

  @override
  int getPoints(Kingdom kingdom, int x, int y) {
    int points = 2;

    if (kingdom.isInBound(x - 1, y - 1) &&
        _checkLand(kingdom.getLand(x - 1, y - 1)!)) {
      points += 2;
    }

    if (kingdom.isInBound(x - 1, y) && _checkLand(kingdom.getLand(x - 1, y)!)) {
      points += 2;
    }

    if (kingdom.isInBound(x - 1, y + 1) &&
        _checkLand(kingdom.getLand(x - 1, y + 1)!)) {
      points += 2;
    }

    if (kingdom.isInBound(x, y - 1) && _checkLand(kingdom.getLand(x, y - 1)!)) {
      points += 2;
    }

    if (kingdom.isInBound(x, y + 1) && _checkLand(kingdom.getLand(x, y + 1)!)) {
      points += 2;
    }

    if (kingdom.isInBound(x + 1, y - 1) &&
        _checkLand(kingdom.getLand(x + 1, y - 1)!)) {
      points += 2;
    }

    if (kingdom.isInBound(x + 1, y) && _checkLand(kingdom.getLand(x + 1, y)!)) {
      points += 2;
    }

    if (kingdom.isInBound(x + 1, y + 1) &&
        _checkLand(kingdom.getLand(x + 1, y + 1)!)) {
      points += 2;
    }

    return points;
  }
}
