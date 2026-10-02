import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/cubits/game_cubit.dart';
import 'package:kingdomino_score_count/cubits/kingdom_cubit.dart';
import 'package:kingdomino_score_count/cubits/rules_cubit.dart';
import 'package:kingdomino_score_count/models/game_set.dart';
import 'package:kingdomino_score_count/models/kingdom.dart';

class ScoreCalculator extends StatelessWidget {
  final Widget child;

  const ScoreCalculator({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<KingdomCubitGreen, Kingdom>(
          listener: (context, kingdom) {
            context.read<GameCubit>().calculateScore(
              KingColor.green,
              kingdom,
              context.read<RulesCubit>().state,
            );
          },
        ),
        BlocListener<KingdomCubitPink, Kingdom>(
          listener: (context, kingdom) {
            context.read<GameCubit>().calculateScore(
              KingColor.pink,
              kingdom,
              context.read<RulesCubit>().state,
            );
          },
        ),
        BlocListener<KingdomCubitYellow, Kingdom>(
          listener: (context, kingdom) {
            context.read<GameCubit>().calculateScore(
              KingColor.yellow,
              kingdom,
              context.read<RulesCubit>().state,
            );
          },
        ),
        BlocListener<KingdomCubitBlue, Kingdom>(
          listener: (context, kingdom) {
            context.read<GameCubit>().calculateScore(
              KingColor.blue,
              kingdom,
              context.read<RulesCubit>().state,
            );
          },
        ),
        BlocListener<KingdomCubitBrown, Kingdom>(
          listener: (context, kingdom) {
            context.read<GameCubit>().calculateScore(
              KingColor.brown,
              kingdom,
              context.read<RulesCubit>().state,
            );
          },
        ),
      ],
      child: child,
    );
  }
}
