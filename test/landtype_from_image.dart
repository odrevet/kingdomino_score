import 'dart:io';

import 'package:kingdomino_score_count/models/land.dart';
import "package:test/test.dart";
import 'package:image/image.dart';

import 'package:kingdomino_score_count/models/picture.dart';

void main() {
  test('Red', () {
    final Image? image =
        decodeImage(File('test/assets/red.png').readAsBytesSync());
    List<int> rgb = averageRGB(image!, 0, 0, image.width, image.height);
    expect(rgb, [0xFF, 0x00, 0x00]);
  });

  test('Blue', () {
    final Image? image =
        decodeImage(File('test/assets/blue.png').readAsBytesSync());
    List<int> rgb = averageRGB(image!, 0, 0, image.width, image.height);
    expect(rgb, [0x00, 0x00, 0xFF]);
  });

  test('Green', () {
    final Image? image =
        decodeImage(File('test/assets/green.png').readAsBytesSync());
    List<int> rgb = averageRGB(image!, 0, 0, image.width, image.height);
    expect([0x00, 0xFF, 0x00], rgb);
  });

  test('Multicolor', () {
    final Image? image =
        decodeImage(File('test/assets/multi.png').readAsBytesSync());
    List<int> rgb = averageRGB(image!, 0, 0, image.width, image.height);
    expect(rgb, [97, 97, 97]);
  });

  test('Camera', () {
    final Image image =
        decodeImage(File('test/assets/camera01_crop.jpg').readAsBytesSync())!;
    int tileWidth = image.width ~/ 5;
    int tileHeight = image.height ~/ 5;
    int x = tileWidth * 3;
    int y = tileHeight * 0;

    List<int> rgb = averageRGB(image, x, y, x + tileWidth, y + tileHeight);
    expect(getLandtypeFromRGB(rgb), LandType.lake);
  });

  test('Wheat', () {
    final Image? image =
        decodeImage(File('test/assets/wheat.png').readAsBytesSync());
    List<int> rgb = averageRGB(image!, 0, 0, image.width, image.height);
    expect(getLandtypeFromRGB(rgb), LandType.wheat);
  });

  test('GrassLand', () {
    final Image? image =
        decodeImage(File('test/assets/grassland.png').readAsBytesSync());
    List<int> rgb = averageRGB(image!, 0, 0, image.width, image.height);
    expect(getLandtypeFromRGB(rgb), LandType.grassland);
  });

  test('Forest', () {
    final Image? image =
        decodeImage(File('test/assets/forest.png').readAsBytesSync());
    List<int> rgb = averageRGB(image!, 0, 0, image.width, image.height);
    expect(getLandtypeFromRGB(rgb), LandType.forest);
  });

  test('Lake', () {
    final Image? image =
        decodeImage(File('test/assets/lake.png').readAsBytesSync());
    List<int> rgb = averageRGB(image!, 0, 0, image.width, image.height);
    expect(getLandtypeFromRGB(rgb), LandType.lake);
  });

  test('Swamp', () {
    final Image? image =
        decodeImage(File('test/assets/swamp.png').readAsBytesSync());
    List<int> rgb = averageRGB(image!, 0, 0, image.width, image.height);
    expect(getLandtypeFromRGB(rgb), LandType.swamp);
  });

  test('Mine', () {
    final Image? image =
        decodeImage(File('test/assets/mine.png').readAsBytesSync());
    List<int> rgb = averageRGB(image!, 0, 0, image.width, image.height);
    expect(getLandtypeFromRGB(rgb), LandType.mine);
  });
}
