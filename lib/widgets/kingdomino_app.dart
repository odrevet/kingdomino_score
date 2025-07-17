import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/cubits/game_cubit.dart';
import 'package:kingdomino_score_count/cubits/kingdom_cubit.dart';
import 'package:kingdomino_score_count/cubits/rules_cubit.dart';
import 'package:kingdomino_score_count/cubits/theme_cubit.dart';

import '../cubits/user_selection_cubit.dart';
import 'kingdomino_widget.dart';

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
          home: MultiBlocProvider(
            providers: [
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
              // ignore: prefer_const_constructors
            ],
            child: KingdominoWidget(),
          ),
        ),
      ),
    );
  }
}
