import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/game.dart';
import '../models/game_set.dart';

class GameCubit extends Cubit<Game> {
  GameCubit() : super(Game(player: Player.blue)) {
    setPlayer(Player.blue);
  }

  void reset() => emit(Game());

  void setPlayer(Player player) {
    emit(state.copyWith(player: player));
  }
}
