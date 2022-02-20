import '../kingdom.dart';
import 'lacour.dart';

class AxeWarrior extends Courtier {
  static final AxeWarrior _singleton = AxeWarrior._internal();

  factory AxeWarrior() {
    return _singleton;
  }

  AxeWarrior._internal();

  @override
  int getPoints(Kingdom kingdom, int x, int y) {
    return 3;
  }
}
