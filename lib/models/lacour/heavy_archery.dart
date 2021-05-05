import '../kingdom.dart';
import 'lacour.dart';

class HeavyArchery extends Courtier {
  static final HeavyArchery _singleton = HeavyArchery._internal();

  factory HeavyArchery() {
    Courtier.isWarrior = true;
    return _singleton;
  }

  HeavyArchery._internal();

  @override
  int getPoints(Kingdom kingdom) {
    return 0;
  }
}
