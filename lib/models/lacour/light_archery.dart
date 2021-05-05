import '../kingdom.dart';
import '../land.dart';
import 'lacour.dart';
class LightArchery extends Courtier {
  static final LightArchery _singleton = LightArchery._internal();

  factory LightArchery() {
    return _singleton;
  }

  LightArchery._internal();

  @override
  int getPoints(Kingdom kingdom, int x, int y) {
    return 4;
  }
}
