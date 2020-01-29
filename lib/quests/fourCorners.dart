import '../kingdom.dart';
import '../quest.dart';

class FourCorners extends Quest {
  final int extraPoints = 5;

  LandType landType;

  FourCorners(this.landType);

  int getPoints(Kingdom kingdom) {
    int count = 0;
    int size = kingdom.size - 1;
    if (kingdom.getLand(0, 0).landType == landType) count++;
    if (kingdom.getLand(size, 0).landType == landType) count++;
    if (kingdom.getLand(0, size).landType == landType) count++;
    if (kingdom.getLand(size, size).landType == landType) count++;

    return extraPoints * count;
  }
}
