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

List<int> averageRGB(Image image) {
  List<int> rgb = [0, 0, 0];

  for (int x = 0; x < image.width; x++) {
    for (int y = 0; y < image.height; y++) {
      int? pixel32 = image.getPixel(x, y);
      rgb[0] += (pixel32 >> 0) & 0xFF;
      rgb[1] += (pixel32 >> 8) & 0xFF;
      rgb[2] += (pixel32 >> 16) & 0xFF;
    }
  }

  int nbPixel = image.width * image.height;
  rgb[0] = (rgb[0] ~/ nbPixel);
  rgb[1] = (rgb[1] ~/ nbPixel);
  rgb[2] = (rgb[2] ~/ nbPixel);

  return rgb;
}
