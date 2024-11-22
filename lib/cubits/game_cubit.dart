import 'dart:collection';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/models/kingdom_size.dart';

import '../models/game.dart';
import '../models/game_set.dart';

class GameCubit extends Cubit<Game> {
  GameCubit()
      : super(Game(
            kingdomSize: KingdomSize.small,
            player: Player.blue,
            selectedQuests: HashSet())) {
    setPlayer(Player.blue);
  }

  void reset() => emit(Game(
      kingdomSize: KingdomSize.small,
      player: Player.blue,
      selectedQuests: HashSet()));

  void setPlayer(Player player) {
    emit(state.copyWith(player: player));
  }
}
