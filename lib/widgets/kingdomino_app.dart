import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/cubits/kingdom_cubit.dart';
import 'package:kingdomino_score_count/cubits/score_cubit.dart';
import 'package:kingdomino_score_count/cubits/theme_cubit.dart';

import 'kingdomino_widget.dart';

class KingdominoApp extends StatelessWidget {
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
            home: MultiBlocProvider(providers: [
              BlocProvider<ScoreCubit>(
                create: (BuildContext context) => ScoreCubit(),
              ),
              BlocProvider<KingdomCubit>(
                create: (BuildContext context) => KingdomCubit(),
              ),
            ], child: KingdominoWidget())),
      ),
    );
  }
}
