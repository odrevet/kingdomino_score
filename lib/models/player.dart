import 'package:kingdomino_score_count/models/score.dart';
import 'package:kingdomino_score_count/models/warning.dart';

import 'game_set.dart';

class Player {
  Player({required this.score, required this.warnings, required this.kingColor});

  KingColor kingColor;
  Score score;
  List<Warning> warnings;

  Player copyWith({
    KingColor? kingColor,
    Score? score,
    List<Warning>? warnings,
  }) {
    return Player(
      kingColor: kingColor ?? this.kingColor,
      score: score ?? this.score,
      warnings: warnings ?? List.from(this.warnings),
    );
  }
}

