import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'widgets/kingdomino_score_widget.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;
  runApp(KingdominoScore(firstCamera));
}

class KingdominoScore extends StatefulWidget {
  final camera;

  KingdominoScore(this.camera);

  @override
  _KingdominoScoreState createState() => _KingdominoScoreState(this.camera);
}

class _KingdominoScoreState extends State<KingdominoScore> {
  Color primaryColor = Colors.blueGrey;
  final camera;

  _KingdominoScoreState(this.camera);

  setColor(Color? color) {
    setState(() {
      if (color == null) {
        this.primaryColor = Colors.blueGrey;
      } else {
        this.primaryColor = color;
      }
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
