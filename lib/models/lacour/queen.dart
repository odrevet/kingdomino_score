import '../kingdom.dart';
import 'lacour.dart';

class Queen extends Courtier {
  static final Queen _singleton = Queen._internal();

  factory Queen() {
    Courtier.isWarrior = false;
    return _singleton;
  }

  Queen._internal();

  @override
  int getPoints(Kingdom kingdom) {
    return 0;
  }
}
