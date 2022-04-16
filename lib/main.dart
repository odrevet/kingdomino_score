import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/kingdom_cubit.dart';
import 'package:kingdomino_score_count/theme_cubit.dart';

import 'widgets/kingdomino_score_widget.dart';

void main() {
  runApp(KingdominoScore());
}

class KingdominoScore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, MaterialColor>(
        builder: (context, color) => MaterialApp(
          title: 'Kingdomino Score',
          theme: ThemeData(
              primarySwatch: color,
              canvasColor: Colors.blueGrey,
              fontFamily: 'HammersmithOne',
              dialogTheme: DialogTheme(
                  backgroundColor: Color.fromARGB(230, 100, 130, 160),
                  contentTextStyle: TextStyle(color: Colors.black))),
          home: BlocProvider(
              create: (_) => KingdomCubit(), child: KingdominoScoreWidget()),
        ),
      ),
    );
  }
}
