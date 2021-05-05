import '../kingdom.dart';
import 'lacour.dart';

class Banker extends Courtier {
  static final Banker _singleton = Banker._internal();

  factory Banker() {
    Courtier.isWarrior = false;
    return _singleton;
  }

  Banker._internal();

  @override
  int getPoints(Kingdom kingdom) {
    return 0;
  }
}
