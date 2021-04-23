import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'dart:ui';

import 'package:image/image.dart';

class ImageProcessor {
  static Future cropSquare(String srcFilePath, String destFilePath) async {
    var bytes = await File(srcFilePath).readAsBytes();
    Image src = decodeImage(bytes)!;

    final int cropSize = min(src.width, src.height);
    int offsetX = (src.width - min(src.width, src.height)) ~/ 2;
    int offsetY = (src.height - min(src.width, src.height)) ~/ 2;

    Image destImage = copyCrop(src, offsetX, offsetY, cropSize, cropSize);

    var jpg = encodeJpg(destImage);
    await File(destFilePath).writeAsBytes(jpg);
  }
}

List<int> readImagePixels(Image image) {
  double px = 0.0;
  double py = 0.0;
  int? pixel32 = image.getPixelSafe(px.toInt(), py.toInt()); //#AABBGGRR
  int b = (pixel32 >> 16) & 0xFF;
  int g = (pixel32 >> 8) & 0xFF;
  int r = pixel32 & 0xFF;
  return [r, g, b];
}
