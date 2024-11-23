import 'dart:collection';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/models/kingdom_size.dart';

import '../models/game.dart';
import '../models/game_set.dart';
import '../models/quests/quest.dart';

class GameCubit extends Cubit<Game> {
  GameCubit()
      : super(Game(
      player: Player.blue,
      kingdomSize: KingdomSize.small,
      selectedQuests: HashSet())) {
    setPlayer(Player.blue);
  }

  void reset() => emit(Game(
      player: Player.blue,
      kingdomSize: KingdomSize.small,
      selectedQuests: HashSet()));

  void setPlayer(Player player) {
    emit(state.copyWith(player: player));
  }

  void addQuest(QuestType quest) {
    if (state.selectedQuests.length < 2) {
      final newQuests = HashSet<QuestType>.from(state.selectedQuests)..add(quest);
      emit(state.copyWith(selectedQuests: newQuests));
    }
  }

  void removeQuest(QuestType quest) {
    final newQuests = HashSet<QuestType>.from(state.selectedQuests)..remove(quest);
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
}
