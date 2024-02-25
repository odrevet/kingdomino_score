import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/cubits/app_state_cubit.dart';
import 'package:kingdomino_score_count/cubits/theme_cubit.dart';
import 'package:provider/provider.dart';
import '../../models/quests/quest.dart';
import 'score_details_widget.dart';
import 'score_pie.dart';

enum DisplayMode {
  score,
  details,
  pie,
}

class ScoreWidget extends StatefulWidget {
  final Function getExtension;

  const ScoreWidget({super.key, required this.getExtension});

  @override
  State<ScoreWidget> createState() => _ScoreWidgetState();
}

class _ScoreWidgetState extends State<ScoreWidget> {
  DisplayMode _displayMode = DisplayMode.score;

  void _cycleDisplayMode() {
    setState(() {
      // Cycle through display modes
      _displayMode = _displayMode == DisplayMode.pie
          ? DisplayMode.score
          : DisplayMode.values[_displayMode.index + 1];
    });
  }

  @override
  Widget build(BuildContext context) {
    int score = context.read<AppStateCubit>().state.score.total;
    return GestureDetector(
      onTap: score > 0 ? _cycleDisplayMode : null,
      child: _displayMode == DisplayMode.score || score == 0
          ? FittedBox(
              fit: BoxFit.fitHeight,
              child: Text(
                score.toString(),
                style: TextStyle(color: context.read<ThemeCubit>().state),
              ),
            )
          : _displayMode == DisplayMode.details
              ? ScoreDetailsWidget(
                  quests: context
                      .read<AppStateCubit>()
                      .state
                      .userSelection
                      .getSelectedQuests(),
                  getExtension: widget.getExtension,
                )
              : FittedBox(fit: BoxFit.fitHeight, child: ScorePie()),
    );
  }
}
