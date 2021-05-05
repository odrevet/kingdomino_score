import '../kingdom.dart';
import 'lacour.dart';

class SwordWarrior extends Courtier {
  static final SwordWarrior _singleton = SwordWarrior._internal();

  factory SwordWarrior() {
    Courtier.isWarrior = true;
    return _singleton;
  }

  SwordWarrior._internal();

  @override
  int getPoints(Kingdom kingdom) {
    return 0;
  }
}
