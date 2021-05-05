import '../kingdom.dart';
import 'lacour.dart';

class Shepherdess extends Courtier {
  static final Shepherdess _singleton = Shepherdess._internal();

  factory Shepherdess() {
    Courtier.isWarrior = false;
    return _singleton;
  }

  Shepherdess._internal();

  @override
  int getPoints(Kingdom kingdom) {
    return 0;
  }
}