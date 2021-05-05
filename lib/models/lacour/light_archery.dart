import '../kingdom.dart';
import 'lacour.dart';

class LightArchery extends Courtier {
  static final LightArchery _singleton = LightArchery._internal();

  factory LightArchery() {
    Courtier.isWarrior = true;
    return _singleton;
  }

  LightArchery._internal();

  @override
  int getPoints(Kingdom kingdom) {
    return 0;
  }
}
