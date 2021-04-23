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

    Image destImage =
    copyCrop(src, offsetX, offsetY, cropSize, cropSize);

    var jpg = encodeJpg(destImage);
    await File(destFilePath).writeAsBytes(jpg);
  }
}

void readImagePixels(Image image)
{
  double px = 0.0;
  double py = 0.0;
  int? pixel32 = image?.getPixelSafe(px.toInt(), py.toInt());  //#AABBGGRR
  int hex = abgrToArgb(pixel32!);
  print(pixel32);
  print(hex);
  int r = (pixel32 >> 16) & 0xFF;
  int b = pixel32 & 0xFF;
  print("r $r b $b");

}

int abgrToArgb(int argbColor) {
  int r = (argbColor >> 16) & 0xFF;
  int b = argbColor & 0xFF;
  return (argbColor & 0xFF00FF00) | (b << 16) | r;
}
