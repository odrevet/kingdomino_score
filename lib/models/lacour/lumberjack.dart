import '../kingdom.dart';
import '../land.dart';
import 'lacour.dart';

class Lumberjack extends Courtier {
  static final Lumberjack _singleton = Lumberjack._internal();

  factory Lumberjack() {
    return _singleton;
  }

  Lumberjack._internal();

  bool _checkLand(Land land) {
    return land.landType == LandType.forest && land.hasResource;
  }

  @override
  int getPoints(Kingdom kingdom, int x, int y) {
    int points = 3;

    if (kingdom.isInBound(x - 1, y - 1) && _checkLand(kingdom.getLand(x - 1, y - 1)!)) {
      points += 3;
    }

    if (kingdom.isInBound(x - 1, y) && _checkLand(kingdom.getLand(x - 1, y)!)) {
      points += 3;
    }

    if (kingdom.isInBound(x - 1, y + 1) && _checkLand(kingdom.getLand(x - 1, y + 1)!)) {
      points += 3;
    }

    if (kingdom.isInBound(x, y - 1) && _checkLand(kingdom.getLand(x, y - 1)!)) {
      points += 3;
    }

    if (kingdom.isInBound(x, y + 1) && _checkLand(kingdom.getLand(x, y + 1)!)) {
      points += 3;
    }

    if (kingdom.isInBound(x + 1, y - 1) && _checkLand(kingdom.getLand(x + 1, y - 1)!)) {
      points += 3;
    }

    if (kingdom.isInBound(x + 1, y) && _checkLand(kingdom.getLand(x + 1, y)!)) {
      points += 3;
    }

    if (kingdom.isInBound(x + 1, y + 1) && _checkLand(kingdom.getLand(x + 1, y + 1)!)) {
      points += 3;
    }

    return points;
  }
}
