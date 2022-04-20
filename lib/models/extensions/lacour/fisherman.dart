import '../../kingdom.dart';
import '../../land.dart';
import 'lacour.dart';

class Fisherman extends Courtier {
  static final Fisherman _singleton = Fisherman._internal();

  factory Fisherman() {
    return _singleton;
  }

  Fisherman._internal();

  bool _checkLand(Land land) {
    return land.landType == LandType.lake && land.hasResource;
  }

  @override
  int getPoints(Kingdom kingdom, int x, int y) {
    int points = 3;

    if (kingdom.isInBound(x - 1, y - 1) &&
        _checkLand(kingdom.getLand(x - 1, y - 1)!)) {
      points += 3;
    }

    if (kingdom.isInBound(x - 1, y) && _checkLand(kingdom.getLand(x - 1, y)!)) {
      points += 3;
    }

    if (kingdom.isInBound(x - 1, y + 1) &&
        _checkLand(kingdom.getLand(x - 1, y + 1)!)) {
      points += 3;
    }

    if (kingdom.isInBound(x, y - 1) && _checkLand(kingdom.getLand(x, y - 1)!)) {
      points += 3;
    }

    if (kingdom.isInBound(x, y + 1) && _checkLand(kingdom.getLand(x, y + 1)!)) {
      points += 3;
    }

    if (kingdom.isInBound(x + 1, y - 1) &&
        _checkLand(kingdom.getLand(x + 1, y - 1)!)) {
      points += 3;
    }

    if (kingdom.isInBound(x + 1, y) && _checkLand(kingdom.getLand(x + 1, y)!)) {
      points += 3;
    }

    if (kingdom.isInBound(x + 1, y + 1) &&
        _checkLand(kingdom.getLand(x + 1, y + 1)!)) {
      points += 3;
    }

    return points;
  }
}
