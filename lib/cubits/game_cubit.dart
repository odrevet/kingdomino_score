import 'dart:collection';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/models/kingdom_size.dart';

import '../models/extensions/extension.dart';
import '../models/game.dart';
import '../models/game_set.dart';
import '../models/kingdom.dart';
import '../models/player.dart';
import '../models/quests/quest.dart';
import '../models/score.dart';

class GameCubit extends Cubit<Game> {
  GameCubit()
      : super(Game(
            kingColor: KingColor.blue,
            kingdomSize: KingdomSize.small,
            selectedQuests: HashSet(),
            players: [
              Player(score: Score(), warnings: [], kingColor: KingColor.blue),
              Player(score: Score(), warnings: [], kingColor: KingColor.green),
              Player(score: Score(), warnings: [], kingColor: KingColor.yellow),
              Player(score: Score(), warnings: [], kingColor: KingColor.pink),
              Player(score: Score(), warnings: [], kingColor: KingColor.brown),
            ])) {
    setPlayer(KingColor.blue);
  }

  void calculateScore(KingColor kingColor, Kingdom kingdom) {
    final newScore = Score.calculateFromKingdom(
        kingdom, state.extension, state.selectedQuests);

    final updatedPlayers = state.players.map((player) {
      return player.kingColor == kingColor
          ? player.copyWith(score: newScore)
          : player;
    }).toList();

    emit(state.copyWith(players: updatedPlayers));
  }

  void reset() => emit(Game(
        kingColor: KingColor.blue,
        kingdomSize: KingdomSize.small,
        selectedQuests: HashSet(),
        players: [],
      ));

  void setPlayer(KingColor kingColor) {
    emit(state.copyWith(kingColor: kingColor));
  }

  void clearQuest() => emit(state.copyWith(selectedQuests: HashSet()));

  void addQuest(QuestType quest) {
    if (state.selectedQuests.length < 2) {
      final newQuests = HashSet<QuestType>.from(state.selectedQuests)
        ..add(quest);
      emit(state.copyWith(selectedQuests: newQuests));
    }
  }

  void removeQuest(QuestType quest) {
    final newQuests = HashSet<QuestType>.from(state.selectedQuests)
      ..remove(quest);
    emit(state.copyWith(selectedQuests: newQuests));
  }

  void toggleQuest(QuestType quest) {
    if (state.selectedQuests.contains(quest)) {
      removeQuest(quest);
    } else if (state.selectedQuests.length < 2) {
      addQuest(quest);
    }
  }

  bool canAddQuest() {
    return state.selectedQuests.length < 2;
  }

  bool hasQuest(QuestType quest) {
    return state.selectedQuests.contains(quest);
  }

  void setWarnings(Kingdom kingdom) {
    final currentPlayer = state.getCurrentPlayer()!;

    final updatedPlayers = state.players.map((player) {
      return player.kingColor == currentPlayer.kingColor
          ? player.copyWith(warnings: checkKingdom(kingdom, state.extension))
          : player;
    }).toList();

    emit(state.copyWith(players: updatedPlayers));
  }

  void setExtension(Extension? extension) =>
      emit(state.copyWith(extension: extension));
}
