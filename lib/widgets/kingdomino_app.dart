import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/cubits/game_cubit.dart';
import 'package:kingdomino_score_count/cubits/kingdom_cubit.dart';
import 'package:kingdomino_score_count/cubits/rules_cubit.dart';
import 'package:kingdomino_score_count/cubits/theme_cubit.dart';

import '../cubits/user_selection_cubit.dart';
import 'global_menu_widget.dart';
import 'score_calculator.dart';

class KingdominoApp extends StatelessWidget {
  const KingdominoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GameCubit>(create: (context) => GameCubit()),
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(context.read<GameCubit>()),
        ),
        BlocProvider<RulesCubit>(
          create: (BuildContext context) => RulesCubit(),
        ),
        BlocProvider<UserSelectionCubit>(
          create: (BuildContext context) => UserSelectionCubit(),
        ),
        BlocProvider<KingdomCubitPink>(
          create: (BuildContext context) => KingdomCubitPink(),
        ),
        BlocProvider<KingdomCubitYellow>(
          create: (BuildContext context) => KingdomCubitYellow(),
        ),
        BlocProvider<KingdomCubitGreen>(
          create: (BuildContext context) => KingdomCubitGreen(),
        ),
        BlocProvider<KingdomCubitBlue>(
          create: (BuildContext context) => KingdomCubitBlue(),
        ),
        BlocProvider<KingdomCubitBrown>(
          create: (BuildContext context) => KingdomCubitBrown(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, MaterialColor>(
        builder: (context, color) => ScoreCalculator(
          child: MaterialApp(
            title: 'Kingdomino Score',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                brightness: MediaQuery.platformBrightnessOf(context),
                seedColor: color,
              ),
              fontFamily: 'HammersmithOne',
            ),
            home: GlobalMenuWidget(),
          ),
        ),
      ),
    );
  }
}
