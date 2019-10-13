import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'mainWidget.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(KingdominoScore());
}

class KingdominoScore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kingdomino Score',
      theme: ThemeData(
          dialogBackgroundColor: Color.fromARGB(225, 90, 120, 150),
          primarySwatch: Colors.brown,
          canvasColor: Colors.blueGrey,
          fontFamily: 'HammersmithOne'),
      home: MainWidget(),
    );
  }
}
