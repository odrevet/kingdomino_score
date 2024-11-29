import 'package:kingdomino_score_count/models/player.dart';

import 'game_set.dart';

class Game {
  Game({required this.players, this.kingColor});

  KingColor? kingColor = KingColor.blue;
  List<Player> players = [];

  Player? getCurrentPlayer() {
    return kingColor != null
        ? players.firstWhere((player) => player.kingColor == kingColor)
        : null;
  }

  // Get player by king color
  Player getPlayerByColor(KingColor color) {
    return players.firstWhere((player) => player.kingColor == color);
  }

  Game copyWith({KingColor? kingColor, List<Player>? players}) => Game(
        kingColor: kingColor ?? this.kingColor,
        players: players ?? this.players,
      );
}
