import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as Image;


// image lib uses uses KML color format, convert #AABBGGRR to regular #AARRGGBB
int abgrToArgb(int argbColor) {
  int r = (argbColor >> 16) & 0xFF;
  int b = argbColor & 0xFF;
  return (argbColor & 0xFF00FF00) | (b << 16) | r;
}

class TakePictureScreen extends StatefulWidget {
  final CameraDescription? camera;

  const TakePictureScreen({
    @required this.camera,
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
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera!,
      // Define the resolution to use.
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
    var size = MediaQuery.of(context).size.width;
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return GestureDetector(
            onTap: () async {
              final xfile = await _controller!.takePicture();
              final Image.Image? image = Image.decodeImage(File(xfile.path).readAsBytesSync());
              double px = 0.0;
              double py = 0.0;
              int? pixel32 = image?.getPixelSafe(px.toInt(), py.toInt());  //#AABBGGRR
              int hex = abgrToArgb(pixel32!);
              Color color = Color(hex);
              print(color.red);
              print(color.green);
              print(color.blue);
            },
            child: Container(
              width: size,
              height: size,
              child: ClipRect(
                child: OverflowBox(
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Container(
                      width: size,
                      height: size,
                      child: CameraPreview(
                          _controller!), // this is my CameraPreview
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
