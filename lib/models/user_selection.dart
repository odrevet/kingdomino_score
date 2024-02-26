import 'dart:collection';

import 'package:kingdomino_score_count/models/quests/quest.dart';

import 'land.dart';

enum SelectionMode { land, crown, castle, giant, courtier, resource }

class UserSelection {
  UserSelection(
      {SelectionMode? selectionMode,
      LandType? selectedLandType,
      HashSet<QuestType>? selectedQuests}) {
    setSelectedLandType(selectedLandType);
    if (selectedQuests != null) this.selectedQuests = selectedQuests;
  }

  SelectionMode selectionMode = SelectionMode.land;
  LandType? selectedLandType = LandType.castle;
  HashSet<QuestType> selectedQuests = HashSet();

  LandType? getSelectedLandType() => selectedLandType;

  HashSet<QuestType> getSelectedQuests() => selectedQuests;

  setSelectionMode(SelectionMode selectionMode) {
    this.selectionMode = selectionMode;
  }

  SelectionMode getSelectionMode() => selectionMode;

  setSelectedLandType(LandType? landType) {
    selectedLandType = landType;
  }

  copyWith(
          {SelectionMode? selectionMode,
          LandType? selectedLandType,
          HashSet<QuestType>? selectedQuests}) =>
      UserSelection(
        selectionMode: selectionMode ?? this.selectionMode,
        selectedLandType: selectedLandType ?? this.selectedLandType,
        selectedQuests: selectedQuests ?? this.selectedQuests,
      );
}
