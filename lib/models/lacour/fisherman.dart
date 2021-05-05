import '../kingdom.dart';
import 'lacour.dart';

class Fisherman extends Courtier {
  static final Fisherman _singleton = Fisherman._internal();

  factory Fisherman() {
    Courtier.isWarrior = false;
    return _singleton;
  }

  Fisherman._internal();

  @override
  int getPoints(Kingdom kingdom) {
    return 0;
  }
}
