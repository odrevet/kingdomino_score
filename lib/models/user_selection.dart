import 'dart:collection';

import 'package:kingdomino_score_count/models/quests/quest.dart';

import 'land.dart';

enum SelectionMode { land, crown, castle, giant, courtier, resource }

class UserSelection {
  UserSelection(
      {LandType? selectedLandType, HashSet<QuestType>? selectedQuests}) {
    setSelectedLandType(selectedLandType);
    if(selectedQuests != null)this.selectedQuests = selectedQuests;
  }

  LandType? selectedLandType = LandType.castle;
  HashSet<QuestType> selectedQuests = HashSet();

  LandType? getSelectedLandType() => selectedLandType;

  HashSet<QuestType> getSelectedQuests() => selectedQuests;

  setSelectedLandType(LandType? landType) {
    selectedLandType = landType;
  }

  copyWith({LandType? selectedLandType, HashSet<QuestType>? selectedQuests}) =>
      UserSelection(
        selectedLandType: selectedLandType ?? this.selectedLandType,
        selectedQuests: selectedQuests ?? this.selectedQuests,
      );
}
