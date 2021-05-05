import '../kingdom.dart';
import '../land.dart';
import 'lacour.dart';

class Shepherdess extends Courtier {
  static final Shepherdess _singleton = Shepherdess._internal();

  factory Shepherdess() {
    return _singleton;
  }

  Shepherdess._internal();

  bool _checkLand(Land land) {
    return land.landType == LandType.wheat && land.hasResource;
  }

  @override
  int getPoints(Kingdom kingdom, int x, int y) {
    int points = 3;

    if (kingdom.isInBound(x - 1, y - 1) && _checkLand(kingdom.getLand(x - 1, y - 1)!)) {
      points += 3;
    }

    if (kingdom.isInBound(x, y - 1) && _checkLand(kingdom.getLand(x - 1, y)!)) {
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