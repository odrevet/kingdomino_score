import 'package:flutter/material.dart';

import 'models/king_colors.dart';
import 'widgets/kingdomino_score_widget.dart';

void main() {
  runApp(KingdominoScore());
}

class KingdominoScore extends StatefulWidget {
  @override
  _KingdominoScoreState createState() => _KingdominoScoreState();
}

class _KingdominoScoreState extends State<KingdominoScore> {
  Color primaryColor = kingColors.first;

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
      home: KingdominoScoreWidget(setColor),
    );
  }
}
