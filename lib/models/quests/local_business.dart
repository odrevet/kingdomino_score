import '../kingdom.dart';
import '../land.dart' show LandType;
import 'quest.dart';

class LocalBusiness extends Quest {
  static final LocalBusiness _singleton = LocalBusiness._internal();

  factory LocalBusiness(LandType landType) {
    _singleton.landType = landType;
    return _singleton;
  }

  LocalBusiness._internal();

  final int extraPoints = 5;

  LandType? landType;

  int getPoints(Kingdom kingdom) {
    int castleX = 0, castleY = 0;

    for (var x = 0; x < kingdom.size; x++) {
      for (var y = 0; y < kingdom.size; y++) {
        if (kingdom.getLand(x, y).landType == LandType.castle) {
          castleX = x;
          castleY = y;
          break;
        }
      }
    }

    int count = 0;
    int x, y;

    x = castleX - 1;
    y = castleY - 1;
    if (kingdom.isInBound(x, y) && kingdom.getLand(x, y).landType == landType)
      count++;

    x = castleX;
    y = castleY - 1;
    if (kingdom.isInBound(x, y) && kingdom.getLand(x, y).landType == landType)
      count++;

    x = castleX + 1;
    y = castleY - 1;
    if (kingdom.isInBound(x, y) && kingdom.getLand(x, y).landType == landType)
      count++;

    x = castleX - 1;
    y = castleY;
    if (kingdom.isInBound(x, y) && kingdom.getLand(x, y).landType == landType)
      count++;

    x = castleX + 1;
    y = castleY;
    if (kingdom.isInBound(x, y) && kingdom.getLand(x, y).landType == landType)
      count++;

    x = castleX - 1;
    y = castleY + 1;
    if (kingdom.isInBound(x, y) && kingdom.getLand(x, y).landType == landType)
      count++;

    x = castleX;
    y = castleY + 1;
    if (kingdom.isInBound(x, y) && kingdom.getLand(x, y).landType == landType)
      count++;

    x = castleX + 1;
    y = castleY + 1;
    if (kingdom.isInBound(x, y) && kingdom.getLand(x, y).landType == landType)
      count++;

    return extraPoints * count;
  }
}
