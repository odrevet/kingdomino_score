import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:kingdomino_score_count/models/kingdom.dart';

import '../models/picture.dart';
import '../models/land.dart';

void saveFile(img.Image image) async {
  Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
  String appDocumentsPath = appDocumentsDirectory.path;
  String filePath = '$appDocumentsPath/out.png';
  File file = File(filePath);
  print(filePath);
  file..writeAsBytesSync(img.encodePng(image));

}

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  final Kingdom kingdom;
  final onTap;

  const TakePictureScreen({
    required this.camera,
    required this.kingdom,
    required this.onTap,
  }) : super();

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.veryHigh,
      enableAudio: false,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller!.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return GestureDetector(
            onTap: () async {
              final xFile = await _controller!.takePicture();
              final img.Image image =
                  img.decodeImage(File(xFile.path).readAsBytesSync())!;
              final img.Image orientedImage = img.bakeOrientation(image);
              final img.Image imageCropped =
                  img.copyCrop(orientedImage, 0, 0, orientedImage.width, orientedImage.width);

              int tileSize = imageCropped.width ~/ widget.kingdom.size;

              print(
                  '${orientedImage.width}:${orientedImage.height} -> ${imageCropped.width}:${imageCropped.height} $tileSize');

              List<img.Image> tiles = [];
              for (int x = 0; x < widget.kingdom.size; x++) {
                for (int y = 0; y < widget.kingdom.size; y++) {
                  img.Image tile = img.copyCrop(imageCropped, x * tileSize,
                      y * tileSize, tileSize, tileSize);

                  tiles.add(tile);
                  LandType? landType = null;  //TODO get land type from opencv
                  if (landType == null) {
                    widget.kingdom.getLand(x, y).landType = LandType.none;
                  } else {
                    widget.kingdom.getLand(x, y).landType = landType;
                  }
                }
              }

              saveFile(tiles[1]);  //DEBUG
              widget.onTap();
            },
            child: CameraPreview(_controller!),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
