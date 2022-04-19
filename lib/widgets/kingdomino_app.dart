import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/cubits/kingdom_cubit.dart';
import 'package:kingdomino_score_count/cubits/score_cubit.dart';
import 'package:kingdomino_score_count/cubits/theme_cubit.dart';

import 'kingdomino_widget.dart';

class KingdominoApp extends StatelessWidget {
  const KingdominoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, MaterialColor>(
        builder: (context, color) => MaterialApp(
            title: 'Kingdomino Score',
            theme: ThemeData(
                primarySwatch: color,
                canvasColor: color.shade200,
                fontFamily: 'HammersmithOne',
                dialogTheme: DialogTheme(
                    backgroundColor: color.shade200,
                    contentTextStyle: const TextStyle(color: Colors.black),
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(20.0))))),
            home: MultiBlocProvider(providers: [
              BlocProvider<ScoreCubit>(
                create: (BuildContext context) => ScoreCubit(),
              ),
              BlocProvider<KingdomCubit>(
                create: (BuildContext context) => KingdomCubit(),
              ),
            ], child: const KingdominoWidget())),
      ),
    );
  }
}
