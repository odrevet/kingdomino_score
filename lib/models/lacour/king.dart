import '../kingdom.dart';
import '../land.dart';
import 'lacour.dart';
class King extends Courtier {
  static final King _singleton = King._internal();

  factory King() {
    return _singleton;
  }

  King._internal();

  bool _checkLand(Land land) {
    return land.crowns > 0;
  }

  @override
  int getPoints(Kingdom kingdom, int x, int y) {
    int points = 0;

    if (kingdom.isInBound(x - 1, y - 1) && _checkLand(kingdom.getLand(x - 1, y - 1)!)) {
      points += 1;
    }

    if (kingdom.isInBound(x - 1, y) && _checkLand(kingdom.getLand(x - 1, y)!)) {
      points += 1;
    }

    if (kingdom.isInBound(x - 1, y + 1) && _checkLand(kingdom.getLand(x - 1, y + 1)!)) {
      points += 1;
    }

    if (kingdom.isInBound(x, y - 1) && _checkLand(kingdom.getLand(x, y - 1)!)) {
      points += 1;
    }

    if (kingdom.isInBound(x, y + 1) && _checkLand(kingdom.getLand(x, y + 1)!)) {
      points += 1;
    }

    if (kingdom.isInBound(x + 1, y - 1) && _checkLand(kingdom.getLand(x + 1, y - 1)!)) {
      points += 1;
    }

    if (kingdom.isInBound(x + 1, y) && _checkLand(kingdom.getLand(x + 1, y)!)) {
      points += 1;
    }

    if (kingdom.isInBound(x + 1, y + 1) && _checkLand(kingdom.getLand(x + 1, y + 1)!)) {
      points += 1;
    }

    return points;
  }
}
