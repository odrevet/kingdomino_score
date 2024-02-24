import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/cubits/score_cubit.dart';
import 'package:kingdomino_score_count/cubits/theme_cubit.dart';
import 'package:provider/provider.dart';
import '../models/quests/quest.dart';
import 'score_details_widget.dart';

class ScoreWidget extends StatefulWidget {
  final HashSet<QuestType> quests;
  final Function getExtension;

  const ScoreWidget(
      {super.key, required this.quests, required this.getExtension});

  @override
  State<ScoreWidget> createState() => _ScoreWidgetState();
}

class _ScoreWidgetState extends State<ScoreWidget> {
  //late bool _showPie = false;
  late bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    int score = context.read<ScoreCubit>().state.score;
    return GestureDetector(
        child: _showDetails && score > 0
            ? ScoreDetailsWidget(
                quests: widget.quests, getExtension: widget.getExtension)
            : FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(score.toString(),
                    style: TextStyle(color: context.read<ThemeCubit>().state)),
              ),
        onTap: () => setState(() {
              if (score > 0) {
                _showDetails = !_showDetails;
              }
            }));
  }
}
