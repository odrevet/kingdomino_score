import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as Img;
import 'package:kingdomino_score_count/models/kingdom.dart';

import '../models/picture.dart';
import '../models/land.dart';

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
      ResolutionPreset.medium,
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
              final Img.Image image =
                  Img.decodeImage(File(xFile.path).readAsBytesSync())!;
              final Img.Image imageCropped =
                  Img.copyCrop(image, 0, 0, image.height, image.height);

              int tileWidth = imageCropped.width ~/ widget.kingdom.size;
              int tileHeight = imageCropped.height ~/ widget.kingdom.size;

              print(
                  '${image.width}:${image.height} -> ${imageCropped.width}:${imageCropped.height} $tileWidth:$tileHeight');

              List<Img.Image> tiles = [];
              for (int x = 0; x < widget.kingdom.size; x++) {
                for (int y = 0; y < widget.kingdom.size; y++) {
                  tiles.add(Img.copyCrop(image, 0, 0, tileWidth, tileHeight));
                  List<int> rgb = averageRGB(
                      imageCropped,
                      x * tileWidth,
                      y * tileHeight,
                      (x * tileWidth) + tileWidth,
                      (y * tileHeight) + tileHeight);
                  LandType? landType = getLandtypeFromRGB(rgb);
                  if (landType == null) {
                    widget.kingdom.getLand(x, y).landType = LandType.none;
                  } else {
                    widget.kingdom.getLand(x, y).landType = landType;
                  }

                  print('$x $y $rgb');
                }
              }

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

