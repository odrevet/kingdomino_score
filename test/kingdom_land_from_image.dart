import 'dart:io';

import "package:test/test.dart";
import 'package:image/image.dart';

import 'package:kingdomino_score_count/models/kingdom.dart';
import 'package:kingdomino_score_count/models/picture.dart';


//TODO calculate average for each land type
Map<LandType, List<int>> landRGB = {
  LandType.swamp: [115, 115, 115],
  LandType.lake: [20, 20, 200],
  LandType.wheat: [250, 210, 20],       //OK
  LandType.mine: [90, 100, 42],
  LandType.forest: [200, 20, 20],
  LandType.grassland: [200, 42, 42],
};


bool compareRGB(List<int> a, List<int> b, {tolerance = 25}) {
  return (a[0] >= b[0] - tolerance && a[0] <= b[0] + tolerance) &&
      (a[1] >= b[1] - tolerance && a[1] <= b[1] + tolerance) &&
      (a[2] >= b[2] - tolerance && a[2] <= b[2] + tolerance);
}

void main() {
  final Image? red = decodeImage(File('test/assets/red.png').readAsBytesSync());
  final Image? green =
      decodeImage(File('test/assets/green.png').readAsBytesSync());
  final Image? blue =
      decodeImage(File('test/assets/blue.png').readAsBytesSync());
  final Image? multi =
      decodeImage(File('test/assets/multi.png').readAsBytesSync());
  final Image? imageWheat =
  decodeImage(File('test/assets/wheat.jpg').readAsBytesSync());


  List<int> redRGB = averageRGB(red!);
  print("Red RGB: $redRGB");

  List<int> greenRGB = averageRGB(green!);
  print("Green RGB: $greenRGB");

  List<int> blueRGB = averageRGB(blue!);
  print("Blue RGB: $blueRGB");

  List<int> multiRGB = averageRGB(multi!);
  print("Multi RGB: $multiRGB");

  List<int> wheatRGB = averageRGB(imageWheat!);
  print("Wheat RGB: $wheatRGB");

  print("Multi");
  landRGB.forEach((key, value) {
    if (compareRGB(multiRGB, value)) {
      print(key);
    }
  });

  print("Wheat");
  landRGB.forEach((key, value) {
    if (compareRGB(wheatRGB, value)) {
      print(key);
    }
  });
}
