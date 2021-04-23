import 'dart:io';

import "package:test/test.dart";
import 'package:image/image.dart';

import 'package:kingdomino_score_count/models/picture.dart';

void main() {
  // Create an image from asset
  final Image? red = decodeImage(File('test/assets/red.jpg').readAsBytesSync());
  final Image? green = decodeImage(File('test/assets/green.jpg').readAsBytesSync());
  final Image? blue = decodeImage(File('test/assets/blue.jpg').readAsBytesSync());

  List<int> rgb;

  rgb = readImagePixels(red!);
  print("Red RGB: $rgb");
  
  rgb = readImagePixels(green!);
  print("Green RGB: $rgb");

  rgb = readImagePixels(blue!);
  print("Blue RGB: $rgb");
}
