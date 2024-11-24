import 'dart:collection';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/models/kingdom_size.dart';

import '../models/extensions/extension.dart';
import '../models/game.dart';
import '../models/game_set.dart';
import '../models/kingdom.dart';
import '../models/quests/quest.dart';
import '../models/score.dart';
import '../models/warning.dart';

class GameCubit extends Cubit<Game> {
  GameCubit()
      : super(Game(
            kingColor: KingColor.blue,
            kingdomSize: KingdomSize.small,
            selectedQuests: HashSet(),
            warnings: [],
            score: Score())) {
    setPlayer(KingColor.blue);
  }

  void calculateScore(Kingdom kingdom) {
    final newScore = Score.calculateFromKingdom(
        kingdom, state.extension, state.getSelectedQuests());
    emit(state.copyWith(score: newScore));
  }

  void reset() => emit(Game(
      kingColor: KingColor.blue,
      kingdomSize: KingdomSize.small,
      warnings: [],
      selectedQuests: HashSet(),
      score: Score()));

  void setPlayer(KingColor kingColor) {
    emit(state.copyWith(kingColor: kingColor));
  }

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

  void clearWarnings() {
    emit(state.copyWith(warnings: []));
  }

  void addWarning(Warning warning) =>
      emit(state.copyWith(warnings: [...state.warnings, warning]));

  void setWarnings(Kingdom kingdom) =>
      emit(state.copyWith(warnings: checkKingdom(kingdom, state.extension)));

  void setExtension(Extension? extension) =>
      emit(state.copyWith(extension: extension));
}
