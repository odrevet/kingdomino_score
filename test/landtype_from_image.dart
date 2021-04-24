import 'dart:io';

import 'package:kingdomino_score_count/models/land.dart';
import "package:test/test.dart";
import 'package:image/image.dart';

import 'package:kingdomino_score_count/models/picture.dart';

void main() {
  test('Red', () {
    final Image? redImage = decodeImage(File('test/assets/red.png').readAsBytesSync());
    List<int> redRGB = averageRGB(redImage!);
    expect([0xFF, 0x00, 0x00], redRGB);
  });

  test('Blue', (){
    final Image? blueImage =
    decodeImage(File('test/assets/blue.png').readAsBytesSync());
    List<int> blueRGB = averageRGB(blueImage!);
    expect([0x00, 0x00, 0xFF], blueRGB);
  });

  test('Green', () {
    final Image? greenImage =
    decodeImage(File('test/assets/green.png').readAsBytesSync());
    List<int> greenRGB = averageRGB(greenImage!);
    expect([0x00, 0xFF, 0x00], greenRGB);
  });

  test('Multicolor', (){
    final Image? multiImage =
    decodeImage(File('test/assets/multi.png').readAsBytesSync());
    List<int> multiRGB = averageRGB(multiImage!);
    expect([97, 97, 97], multiRGB);
  });

  test('Wheat', (){
    final Image? imageWheat =
    decodeImage(File('test/assets/wheat.jpg').readAsBytesSync());
    List<int> wheatRGB = averageRGB(imageWheat!);
    expect(LandType.wheat, getLandtypeFromRGB(wheatRGB));
  });
}
