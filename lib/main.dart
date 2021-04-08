import 'package:flutter/material.dart';

import 'widgets/main_widget.dart';

void main() {
  runApp(KingdominoScore());
}

class KingdominoScore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kingdomino Score',
      theme: ThemeData(
          dialogBackgroundColor: Color.fromARGB(230, 100, 130, 160),
          primarySwatch: Colors.brown,
          canvasColor: Colors.blueGrey,
          fontFamily: 'HammersmithOne'),
      home: MainWidget(),
    );
  }
}
