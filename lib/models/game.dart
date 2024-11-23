import 'dart:collection';

import 'package:kingdomino_score_count/models/quests/quest.dart';

import 'extensions/extension.dart';
import 'game_set.dart';
import 'kingdom_size.dart';

class Game {
  Game(
      {this.extension,
      required this.kingdomSize,
      required this.selectedQuests,
      this.player});

  Player? player;
  KingdomSize kingdomSize = KingdomSize.small;
  HashSet<QuestType> selectedQuests = HashSet();
  Extension? extension;

  HashSet<QuestType> getSelectedQuests() => selectedQuests;

  copyWith(
          {Player? player,
          KingdomSize? kingdomSize,
          Extension? extension,
          HashSet<QuestType>? selectedQuests}) =>
      Game(
        player: player ?? this.player,
        kingdomSize: kingdomSize ?? this.kingdomSize,
        extension: extension ?? this.extension,
        selectedQuests: selectedQuests ?? this.selectedQuests,
      );
}
