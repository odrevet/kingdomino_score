import 'dart:io';

import "package:test/test.dart";
import 'package:image/image.dart';

import 'package:kingdomino_score_count/models/kingdom.dart';
import 'package:kingdomino_score_count/models/picture.dart';

bool compareRGB(List<int> a, List<int> b, {tolerance = 25}) {
  return (a[0] >= b[0] - tolerance && a[0] <= b[0] + tolerance) &&
      (a[1] >= b[1] - tolerance && a[1] <= b[1] + tolerance) &&
      (a[2] >= b[2] - tolerance && a[2] <= b[2] + tolerance);
}

void main() {
  final Image? red = decodeImage(File('test/assets/red.jpg').readAsBytesSync());
  final Image? green =
      decodeImage(File('test/assets/green.jpg').readAsBytesSync());
  final Image? blue =
      decodeImage(File('test/assets/blue.jpg').readAsBytesSync());
  final Image? multi =
      decodeImage(File('test/assets/multi.jpg').readAsBytesSync());

  List<int> redRGB = averageRGB(red!);
  print("Red RGB: $redRGB");

  List<int> greenRGB = averageRGB(green!);
  print("Green RGB: $greenRGB");

  List<int> blueRGB = averageRGB(blue!);
  print("Blue RGB: $blueRGB");

  List<int> multiRGB = averageRGB(multi!);
  print("Multi RGB: $multiRGB");

  //TODO calculate average for each land type
  List<int> swampRGB = [115, 115, 115];
  List<int> lakeRGB = [20, 20, 200];
  List<int> wheatRGB = [42, 42, 42];
  List<int> mineRGB = [90, 100, 42];
  List<int> forestRGB = [200, 20, 20];
  List<int> grasslandRGB = [200, 42, 42];

  Map<LandType, List<int>> landRGB = {
    LandType.swamp: swampRGB,
    LandType.lake: lakeRGB,
    LandType.wheat: wheatRGB,
    LandType.mine: mineRGB,
    LandType.forest: forestRGB,
    LandType.grassland: grasslandRGB,
  };

  landRGB.forEach((key, value) {
    if (compareRGB(multiRGB, value)) {
      print(key);
    }
  });
}
