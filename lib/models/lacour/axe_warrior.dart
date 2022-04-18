import '../kingdom.dart';
import 'lacour.dart';

class AxeWarrior extends Courtier {
  static final AxeWarrior _singleton = AxeWarrior._internal();

  factory AxeWarrior() {
    return _singleton;
  }

  AxeWarrior._internal() : super(isWarrior: true);

  @override
  int getPoints(Kingdom kingdom, int x, int y) => 3;
}
