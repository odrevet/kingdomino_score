import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/game.dart';
import '../models/kingdom.dart';
import '../models/score.dart';
import 'game_cubit.dart';
import 'kingdom_cubit.dart';

class ScoreCubit extends Cubit<Score> {
  final KingdomCubit kingdomCubit;
  final GameCubit gameCubit;
  late final StreamSubscription kingdomSubscription;
  late final StreamSubscription gameSubscription;

  ScoreCubit({
    required this.kingdomCubit,
    required this.gameCubit,
  }) : super(const Score()) {
    // Subscribe to changes in KingdomCubit
    kingdomSubscription = kingdomCubit.stream.listen((kingdom) {
      updateScore(kingdom, gameCubit.state);
    });

    // Subscribe to changes in GameCubit
    gameSubscription = gameCubit.stream.listen((game) {
      updateScore(kingdomCubit.state, game);
    });
  }

  void updateScore(Kingdom kingdom, Game game) {
    final newScore = Score.calculateFromKingdom(
        kingdom, game.extension, game.getSelectedQuests());
    emit(newScore);
  }

  void reset() {
    emit(const Score());
  }

  @override
  Future<void> close() {
    kingdomSubscription.cancel();
    gameSubscription.cancel();
    return super.close();
  }
}
