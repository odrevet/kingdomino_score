import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/cubits/game_cubit.dart';
import 'package:kingdomino_score_count/cubits/kingdom_cubit.dart';
import 'package:kingdomino_score_count/cubits/theme_cubit.dart';

import '../cubits/user_selection_cubit.dart';
import '../models/game_set.dart';
import 'kingdomino_widget.dart';

class KingdominoApp extends StatelessWidget {
  const KingdominoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GameCubit>(
          create: (context) => GameCubit(),
        ),
        BlocProvider<ThemeCubit>(
            create: (context) => ThemeCubit(context.read<GameCubit>()))
      ],
      child: BlocBuilder<ThemeCubit, MaterialColor>(
        builder: (context, color) => MaterialApp(
            title: 'Kingdomino Score',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                brightness: MediaQuery.platformBrightnessOf(context),
                seedColor: color,
              ),
              fontFamily: 'HammersmithOne',
            ),
            home: MultiBlocProvider(providers: [
              BlocProvider<UserSelectionCubit>(
                create: (BuildContext context) => UserSelectionCubit(),
              ),
              BlocProvider<KingdomCubit>(
                  create: (BuildContext context) =>
                      KingdomCubit(player: KingColors.blue)),
              // ignore: prefer_const_constructors
            ], child: KingdominoWidget())),
      ),
    );
  }
}
