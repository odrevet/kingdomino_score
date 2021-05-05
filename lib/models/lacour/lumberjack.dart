import '../kingdom.dart';
import 'lacour.dart';

class Lumberjack extends Courtier {
  static final Lumberjack _singleton = Lumberjack._internal();

  factory Lumberjack() {
    Courtier.isWarrior = false;
    return _singleton;
  }

  Lumberjack._internal();

  @override
  int getPoints(Kingdom kingdom) {
    return 0;
  }
}
