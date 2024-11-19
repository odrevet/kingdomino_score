import 'dart:collection';

import 'package:kingdomino_score_count/models/quests/quest.dart';

import 'extensions/extension.dart';

class Rules {
  Rules({Extension? extension, HashSet<QuestType>? selectedQuests}) {
    if (selectedQuests != null) this.selectedQuests = selectedQuests;
  }

  bool largeKingdom = false; // 7x7 kingdom if true, 5 otherwise
  HashSet<QuestType> selectedQuests = HashSet();
  Extension? extension;

  HashSet<QuestType> getSelectedQuests() => selectedQuests;

  copyWith({Extension? extension, HashSet<QuestType>? selectedQuests}) => Rules(
        extension: extension ?? this.extension,
        selectedQuests: selectedQuests ?? this.selectedQuests,
      );
}
