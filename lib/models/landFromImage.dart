import 'dart:io';

import 'package:image/image.dart';
import 'package:kingdomino_score_count/models/opencv.dart';
import 'package:path_provider/path_provider.dart';

import '../models/land.dart';

List<Land> lands = [
  Land(LandType.wheat),
  Land(LandType.wheat),
  Land(LandType.grassland),
  Land(LandType.grassland),
  Land(LandType.wheat, 1),
  Land(LandType.grassland),
  Land(LandType.lake, 1),
  Land(LandType.wheat),
  Land(LandType.wheat),
  Land(LandType.grassland, 2),
  Land(LandType.wheat),
  Land(LandType.wheat),
  Land(LandType.swamp),
  Land(LandType.swamp),
  Land(LandType.wheat, 1),
  Land(LandType.swamp),
  Land(LandType.lake, 1),
  Land(LandType.forest),
  Land(LandType.lake),
  Land(LandType.grassland, 2),
  Land(LandType.forest),
  Land(LandType.forest),
  Land(LandType.wheat),
  Land(LandType.forest),
  Land(LandType.wheat, 1),
  Land(LandType.mine),
  Land(LandType.lake, 1),
  Land(LandType.forest),
  Land(LandType.wheat),
  Land(LandType.swamp, 2),
  Land(LandType.forest),
  Land(LandType.forest),
  Land(LandType.wheat),
  Land(LandType.lake),
  Land(LandType.forest, 1),
  Land(LandType.wheat),
  Land(LandType.lake, 1),
  Land(LandType.forest),
  Land(LandType.grassland),
  Land(LandType.swamp, 2),
  Land(LandType.forest),
  Land(LandType.forest),
  Land(LandType.wheat),
  Land(LandType.grassland),
  Land(LandType.forest, 1),
  Land(LandType.wheat),
  Land(LandType.lake, 1),
  Land(LandType.forest),
  Land(LandType.mine, 2),
  Land(LandType.wheat),
  Land(LandType.forest),
  Land(LandType.forest),
  Land(LandType.wheat),
  Land(LandType.swamp),
  Land(LandType.forest, 1),
  Land(LandType.wheat),
  Land(LandType.wheat),
  Land(LandType.grassland, 1),
  Land(LandType.swamp),
  Land(LandType.mine, 2),
  Land(LandType.lake),
  Land(LandType.lake),
  Land(LandType.forest),
  Land(LandType.lake),
  Land(LandType.forest, 1),
  Land(LandType.wheat),
  Land(LandType.lake),
  Land(LandType.grassland, 1),
  Land(LandType.swamp),
  Land(LandType.mine, 2),
  Land(LandType.lake),
  Land(LandType.lake),
  Land(LandType.forest),
  Land(LandType.grassland),
  Land(LandType.forest, 1),
  Land(LandType.lake),
  Land(LandType.wheat),
  Land(LandType.swamp, 1),
  Land(LandType.wheat),
  Land(LandType.mine, 3),
  Land(LandType.lake),
  Land(LandType.lake),
  Land(LandType.wheat, 1),
  Land(LandType.forest),
  Land(LandType.forest, 1),
  Land(LandType.grassland),
  Land(LandType.grassland),
  Land(LandType.swamp, 1),
  Land(LandType.grassland),
  Land(LandType.grassland),
  Land(LandType.wheat, 1),
  Land(LandType.lake),
  Land(LandType.lake, 1),
  Land(LandType.wheat),
  Land(LandType.mine, 1),
  Land(LandType.wheat),
];

landFromImage(kingdom, file) async {
  final Image image = decodeImage(file.readAsBytesSync())!;
  final Image orientedImage = bakeOrientation(image);
  int tileSize = orientedImage.width ~/ kingdom.size;
  Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
  String appDocumentsPath = appDocumentsDirectory.path;

  for (int x = 0; x < kingdom.size; x++) {
    for (int y = 0; y < kingdom.size; y++) {
      Image tile = copyCrop(
          orientedImage, x * tileSize, y * tileSize, tileSize, tileSize);

      String filePath = '$appDocumentsPath/$x-$y.png';
      File file = File(filePath);
      file..writeAsBytesSync(encodePng(tile));

      print("PROCESS $filePath");

      int index = processImage(filePath);

      print(index);
      kingdom.setLand(y, x, lands[index]);
    }
  }
}
