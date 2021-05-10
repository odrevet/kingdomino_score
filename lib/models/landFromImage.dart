import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:kingdomino_score_count/models/opencv.dart';
import 'package:path_provider/path_provider.dart';

import '../models/land.dart';

landFromImage(kingdom, filepath) async {
  final img.Image image = img.decodeImage(File(filepath).readAsBytesSync())!;
  final img.Image orientedImage = img.bakeOrientation(image);
  final img.Image imageCropped = img.copyCrop(
      orientedImage, 0, 0, orientedImage.width, orientedImage.width);

  int tileSize = imageCropped.width ~/ kingdom.size;

  print(
      '${orientedImage.width}:${orientedImage.height} -> ${imageCropped.width}:${imageCropped.height} $tileSize');

  Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
  String appDocumentsPath = appDocumentsDirectory.path;

  for (int x = 0; x < kingdom.size; x++) {
    for (int y = 0; y < kingdom.size; y++) {
      img.Image tile = img.copyCrop(
          imageCropped, x * tileSize, y * tileSize, tileSize, tileSize);

      String filePath = '$appDocumentsPath/$x-$y.png';
      File file = File(filePath);
      file..writeAsBytesSync(img.encodePng(image));

      var processImageArguments = ProcessImageArguments(
          filePath, filePath); //TODO compare with game set
      double score = processImage(processImageArguments);
      print("$filePath SCORE IS $score");

      LandType? landType = null; //TODO get land type from opencv
      kingdom.getLand(x, y).landType = landType;
    }
  }
}
