import '../kingdom.dart';
import '../quest.dart';

class LocalBusiness extends Quest {
  final int extraPoints = 5;

  final LandType landType;

  LocalBusiness(this.landType);

  int getPoints(Kingdom kingdom) {
    int castleX, castleY;

    for (var x = 0; x < kingdom.size; x++) {
      for (var y = 0; y < kingdom.size; y++) {
        if (kingdom.getLand(x, y).landType == LandType.castle) {
          castleX = x;
          castleY = y;
          break;
        }
      }
    }

    if (castleX == null) return 0;

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
