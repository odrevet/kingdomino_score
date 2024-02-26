import 'dart:collection';

import 'package:kingdomino_score_count/models/quests/quest.dart';

import 'extensions/extension.dart';
import 'extensions/lacour/lacour.dart';
import 'land.dart';

enum SelectionMode { land, crown, castle, giant, courtier, resource }

class UserSelection {
  UserSelection(
      {SelectionMode? selectionMode,
      LandType? selectedLandType,
      Extension? extension,
      Courtier? selectedCourtier,
      HashSet<QuestType>? selectedQuests}) {
    setSelectedLandType(selectedLandType);
    if (selectedQuests != null) this.selectedQuests = selectedQuests;
  }

  SelectionMode selectionMode = SelectionMode.land;
  LandType? selectedLandType = LandType.castle;
  HashSet<QuestType> selectedQuests = HashSet();
  Extension? extension;
  Courtier? selectedCourtier;

  LandType? getSelectedLandType() => selectedLandType;

  HashSet<QuestType> getSelectedQuests() => selectedQuests;

  setSelectionMode(SelectionMode selectionMode) {
    this.selectionMode = selectionMode;
  }

  SelectionMode getSelectionMode() => selectionMode;

  setSelectedLandType(LandType? landType) {
    selectedLandType = landType;
  }

  setSelectedCourtier(Courtier courtier) {
    selectedCourtier = courtier;
  }

  copyWith(
          {SelectionMode? selectionMode,
          Extension? extension,
          LandType? selectedLandType,
          Courtier? selectedCourtier,
          HashSet<QuestType>? selectedQuests}) =>
      UserSelection(
        selectionMode: selectionMode ?? this.selectionMode,
        extension: extension ?? this.extension,
        selectedLandType: selectedLandType ?? this.selectedLandType,
        selectedCourtier: selectedCourtier ?? this.selectedCourtier,
        selectedQuests: selectedQuests ?? this.selectedQuests,
      );
}
