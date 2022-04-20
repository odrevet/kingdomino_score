import '../../kingdom.dart';
import '../../land.dart';
import 'lacour.dart';

class King extends Courtier {
  static final King _singleton = King._internal();

  factory King() {
    return _singleton;
  }

  King._internal();

  @override
  int getPoints(Kingdom kingdom, int x, int y) {
    int points = 0;

    if (kingdom.isInBound(x - 1, y - 1)) {
      Land land = kingdom.getLand(x - 1, y - 1)!;
      points += land.crowns;
    }

    if (kingdom.isInBound(x - 1, y)) {
      Land land = kingdom.getLand(x - 1, y)!;
      points += land.crowns;
    }

    if (kingdom.isInBound(x - 1, y + 1)) {
      Land land = kingdom.getLand(x - 1, y + 1)!;
      points += land.crowns;
    }

    if (kingdom.isInBound(x, y - 1)) {
      Land land = kingdom.getLand(x, y - 1)!;
      points += land.crowns;
    }

    if (kingdom.isInBound(x, y + 1)) {
      Land land = kingdom.getLand(x, y + 1)!;
      points += land.crowns;
    }

    if (kingdom.isInBound(x + 1, y - 1)) {
      Land land = kingdom.getLand(x + 1, y - 1)!;
      points += land.crowns;
    }

    if (kingdom.isInBound(x + 1, y)) {
      Land land = kingdom.getLand(x + 1, y)!;
      points += land.crowns;
    }

    if (kingdom.isInBound(x + 1, y + 1)) {
      Land land = kingdom.getLand(x + 1, y + 1)!;
      points += land.crowns;
    }

    return points;
  }
}
