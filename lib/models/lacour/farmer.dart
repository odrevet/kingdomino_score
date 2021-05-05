import '../kingdom.dart';
import 'lacour.dart';

class Farmer extends Courtier {
  static final Farmer _singleton = Farmer._internal();

  factory Farmer() {
    Courtier.isWarrior = false;
    return _singleton;
  }

  Farmer._internal();

  @override
  int getPoints(Kingdom kingdom) {
    return 0;
  }
}
