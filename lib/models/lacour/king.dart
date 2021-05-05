import '../kingdom.dart';
import 'lacour.dart';

class King extends Courtier {
  static final King _singleton = King._internal();

  factory King() {
    Courtier.isWarrior = false;
    return _singleton;
  }

  King._internal();

  @override
  int getPoints(Kingdom kingdom) {
    return 0;
  }
}
