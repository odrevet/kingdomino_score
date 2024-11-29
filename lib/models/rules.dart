import 'dart:collection';

import 'package:kingdomino_score_count/models/quests/quest.dart';

import 'extensions/extension.dart';
import 'kingdom_size.dart';

class Rules {
  Rules(
      {this.extension = Extension.vanilla,
      required this.kingdomSize,
      required this.selectedQuests});

  KingdomSize kingdomSize = KingdomSize.small;
  HashSet<QuestType> selectedQuests = HashSet();
  Extension extension;

  Rules copyWith({
    KingdomSize? kingdomSize,
    Extension? extension,
    HashSet<QuestType>? selectedQuests,
  }) =>
      Rules(
          kingdomSize: kingdomSize ?? this.kingdomSize,
          extension: extension ?? this.extension,
          selectedQuests: selectedQuests ?? this.selectedQuests);
}
