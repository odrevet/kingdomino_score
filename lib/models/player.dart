import 'package:kingdomino_score_count/models/score.dart';
import 'package:kingdomino_score_count/models/warning.dart';

import 'game_set.dart';

class Player {
  Player(
      {required this.score, required this.warnings, required this.kingColor});

  KingColor kingColor;
  Score score = Score();
  List<Warning> warnings = [];
}
