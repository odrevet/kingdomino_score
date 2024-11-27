import 'dart:collection';

import 'package:kingdomino_score_count/models/player.dart';
import 'package:kingdomino_score_count/models/quests/quest.dart';

import 'extensions/extension.dart';
import 'game_set.dart';
import 'kingdom_size.dart';

class Game {
  Game(
      {this.extension = Extension.vanilla,
      required this.kingdomSize,
      required this.selectedQuests,
      required this.players,
      this.kingColor});

  KingColor? kingColor = KingColor.blue;
  List<Player> players = [];
  KingdomSize kingdomSize = KingdomSize.small;
  HashSet<QuestType> selectedQuests = HashSet();
  Extension extension;

  Player? getCurrentPlayer() {
    return kingColor != null
        ? players.firstWhere((player) => player.kingColor == kingColor)
        : null;
  }

  // Get player by king color
  Player getPlayerByColor(KingColor color) {
    return players.firstWhere((player) => player.kingColor == color);
  }

  Game copyWith({
    KingColor? kingColor,
    KingdomSize? kingdomSize,
    Extension? extension,
    List<Player>? players,
    HashSet<QuestType>? selectedQuests,
  }) =>
      Game(
        kingColor: kingColor ?? this.kingColor,
        kingdomSize: kingdomSize ?? this.kingdomSize,
        extension: extension ?? this.extension,
        selectedQuests: selectedQuests ?? this.selectedQuests,
        players: players ?? this.players,
      );
}
