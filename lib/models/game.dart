import 'dart:collection';

import 'package:kingdomino_score_count/models/quests/quest.dart';
import 'package:kingdomino_score_count/models/score.dart';
import 'package:kingdomino_score_count/models/warning.dart';

import 'extensions/extension.dart';
import 'game_set.dart';
import 'kingdom_size.dart';

class Game {
  Game(
      {this.extension,
      required this.kingdomSize,
      required this.selectedQuests,
      required this.score,
      required this.warnings,
      this.kingColor});

  KingColor? kingColor;
  KingdomSize kingdomSize = KingdomSize.small;
  HashSet<QuestType> selectedQuests = HashSet();
  Extension? extension;
  Score score;
  List<Warning> warnings = [];

  HashSet<QuestType> getSelectedQuests() => selectedQuests;

  copyWith(
          {KingColor? kingColor,
          List<Warning>? warnings,
          Score? score,
          KingdomSize? kingdomSize,
          Extension? extension,
          HashSet<QuestType>? selectedQuests}) =>
      Game(
        kingColor: kingColor ?? this.kingColor,
        score: score ?? this.score,
        warnings: warnings ?? this.warnings,
        kingdomSize: kingdomSize ?? this.kingdomSize,
        extension: extension ?? this.extension,
        selectedQuests: selectedQuests ?? this.selectedQuests,
      );
}
