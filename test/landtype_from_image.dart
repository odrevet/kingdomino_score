import 'dart:io';

import 'package:kingdomino_score_count/models/land.dart';
import "package:test/test.dart";
import 'package:image/image.dart';

import 'package:kingdomino_score_count/models/picture.dart';

void main() {
  test('Red', () {
    final Image? image =
        decodeImage(File('test/assets/red.png').readAsBytesSync());
    List<int> redRGB = averageRGB(image!, 0, 0, image.width, image.height);
    expect([0xFF, 0x00, 0x00], redRGB);
  });

  test('Blue', () {
    final Image? image =
        decodeImage(File('test/assets/blue.png').readAsBytesSync());
    List<int> blueRGB = averageRGB(image!, 0, 0, image.width, image.height);
    expect([0x00, 0x00, 0xFF], blueRGB);
  });

  test('Green', () {
    final Image? image =
        decodeImage(File('test/assets/green.png').readAsBytesSync());
    List<int> greenRGB = averageRGB(image!, 0, 0, image.width, image.height);
    expect([0x00, 0xFF, 0x00], greenRGB);
  });

  test('Multicolor', () {
    final Image? image =
        decodeImage(File('test/assets/multi.png').readAsBytesSync());
    List<int> multiRGB = averageRGB(image!, 0, 0, image.width, image.height);
    expect([97, 97, 97], multiRGB);
  });

  test('Wheat', () {
    final Image? image =
        decodeImage(File('test/assets/wheat.jpg').readAsBytesSync());
    List<int> wheatRGB = averageRGB(image!, 0, 0, image.width, image.height);
    expect(LandType.wheat, getLandtypeFromRGB(wheatRGB));
  });

  test('Camera', () {
    final Image? image =
    decodeImage(File('test/assets/camera.png').readAsBytesSync());
    List<int> RGB = averageRGB(image!, 0, 0, image.width, image.height);
    print(RGB);
  });
}
