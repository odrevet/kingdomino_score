import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:async' show Future;
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

import 'models/king_colors.dart';
import 'widgets/kingdomino_score_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  //Copy from assets to app doccument
  /*for(int index = 0; index <= 95; index++){
    final path = "assets/histograms/${index}.json";
    final Directory docDir = await getApplicationDocumentsDirectory();
    final String localPath = docDir.path;
    File file = File('$localPath/${path.split('/').last}');
    final imageBytes = await rootBundle.load(path);
    final buffer = imageBytes.buffer;
    await file.writeAsBytes(
        buffer.asUint8List(imageBytes.offsetInBytes, imageBytes.lengthInBytes));
  }*/

  for(int index = 0; index <= 95; index++){
    final path = "assets/tiles/${index}.jpg";
    final Directory docDir = await getApplicationDocumentsDirectory();
    final String localPath = docDir.path;
    File file = File('$localPath/${path.split('/').last}');
    final imageBytes = await rootBundle.load(path);
    final buffer = imageBytes.buffer;
    await file.writeAsBytes(
        buffer.asUint8List(imageBytes.offsetInBytes, imageBytes.lengthInBytes));
  }

  runApp(KingdominoScore(firstCamera));
}

class KingdominoScore extends StatefulWidget {
  final camera;

  KingdominoScore(this.camera);

  @override
  _KingdominoScoreState createState() => _KingdominoScoreState(this.camera);
}

class _KingdominoScoreState extends State<KingdominoScore> {
  Color primaryColor = kingColors.first;
  final camera;

  _KingdominoScoreState(this.camera);

  setColor(Color color) {
    setState(() {
      this.primaryColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kingdomino Score',
      theme: ThemeData(
          primaryColor: this.primaryColor,
          canvasColor: Colors.blueGrey,
          fontFamily: 'HammersmithOne',
          dialogTheme: DialogTheme(
              backgroundColor: Color.fromARGB(230, 100, 130, 160),
              contentTextStyle: TextStyle(color: Colors.black))),
      home: KingdominoScoreWidget(setColor, this.camera),
    );
  }
}
