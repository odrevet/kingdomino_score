import 'dart:collection';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/models/kingdom_size.dart';

import '../models/extensions/extension.dart';
import '../models/quests/quest.dart';
import '../models/rules.dart';

class RulesCubit extends Cubit<Rules> {
  RulesCubit()
    : super(Rules(kingdomSize: KingdomSize.small, selectedQuests: HashSet()));

  void reset() =>
      emit(Rules(kingdomSize: KingdomSize.small, selectedQuests: HashSet()));

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

  void setExtension(Extension? extension) =>
      emit(state.copyWith(extension: extension));
}
