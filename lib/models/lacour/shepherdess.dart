import '../kingdom.dart';
import '../land.dart';
import 'lacour.dart';

class Shepherdess extends Courtier {
  static final Shepherdess _singleton = Shepherdess._internal();

  factory Shepherdess() {
    return _singleton;
  }

  Shepherdess._internal();

  @override
  int getPoints(Kingdom kingdom, int x, int y) {
    return 0;
  }
}