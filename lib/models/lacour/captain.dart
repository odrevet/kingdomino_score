import '../kingdom.dart';
import 'lacour.dart';

class Captain extends Courtier {
  static final Captain _singleton = Captain._internal();

  factory Captain() {
    Courtier.isWarrior = true;
    return _singleton;
  }

  Captain._internal();

  @override
  int getPoints(Kingdom kingdom) {
    return 0;
  }
}