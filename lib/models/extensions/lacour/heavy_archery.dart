import '../../kingdom.dart';
import 'lacour.dart';

class HeavyArchery extends Courtier {
  static final HeavyArchery _singleton = HeavyArchery._internal();

  factory HeavyArchery() {
    return _singleton;
  }

  HeavyArchery._internal() : super(isWarrior: true);

  @override
  int getPoints(Kingdom kingdom, int x, int y) {
    return 4;
  }
}
