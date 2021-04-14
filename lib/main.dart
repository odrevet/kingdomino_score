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
          primarySwatch: Colors.brown,
          canvasColor: Colors.blueGrey,
          fontFamily: 'HammersmithOne',
          dialogTheme: DialogTheme(
              backgroundColor: Color.fromARGB(230, 100, 130, 160),
              contentTextStyle: TextStyle(color: Colors.black))),
      home: MainWidget(),
    );
  }
}
