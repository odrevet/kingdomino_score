import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/kingdom_cubit.dart';

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
  MaterialColor primaryColor = kingColors.first;

  setColor(MaterialColor color) {
    setState(() {
      this.primaryColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kingdomino Score',
      theme: ThemeData(
          primarySwatch: this.primaryColor,
          canvasColor: Colors.blueGrey,
          fontFamily: 'HammersmithOne',
          dialogTheme: DialogTheme(
              backgroundColor: Color.fromARGB(230, 100, 130, 160),
              contentTextStyle: TextStyle(color: Colors.black))),
      home: BlocProvider(
          create: (_) => KingdomCubit(),
          child: KingdominoScoreWidget(setColor)),
    );
  }
}
