import '../../kingdom.dart';
import '../../land.dart';
import 'lacour.dart';

class Captain extends Courtier {
  static final Captain _singleton = Captain._internal();

  factory Captain() {
    return _singleton;
  }

  Captain._internal() : super(isWarrior: true);

  bool _checkLand(Land? land) => land?.courtier?.isWarrior == true;

  @override
  int getPoints(Kingdom kingdom, int x, int y) {
    int points = 1;

    if (kingdom.isInBound(x, y) && _checkLand(kingdom.getLand(x - 1, y - 1))) {
      points += 3;
    }

    if (kingdom.isInBound(x, y) && _checkLand(kingdom.getLand(x - 1, y))) {
      points += 3;
    }

    if (kingdom.isInBound(x, y) && _checkLand(kingdom.getLand(x - 1, y + 1))) {
      points += 3;
    }

    if (kingdom.isInBound(x, y) && _checkLand(kingdom.getLand(x, y - 1))) {
      points += 3;
    }

    if (kingdom.isInBound(x, y) && _checkLand(kingdom.getLand(x, y + 1))) {
      points += 3;
    }

    if (kingdom.isInBound(x, y) && _checkLand(kingdom.getLand(x + 1, y - 1))) {
      points += 3;
    }

    if (kingdom.isInBound(x, y) && _checkLand(kingdom.getLand(x + 1, y))) {
      points += 3;
    }

    if (kingdom.isInBound(x, y) && _checkLand(kingdom.getLand(x + 1, y + 1))) {
      points += 3;
    }

    return points;
  }
}
