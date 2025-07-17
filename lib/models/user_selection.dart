import 'dart:collection';

import 'package:kingdomino_score_count/models/quests/quest.dart';

import 'extensions/extension.dart';
import 'extensions/lacour/lacour.dart';
import 'land.dart';

enum SelectionMode { land, crown, castle, giant, courtier, resource }

class UserSelection {
  UserSelection({
    required this.selectionMode,
    this.selectedLandType,
    this.selectedCourtier,
  }) {
    setSelectedLandType(selectedLandType);
  }

  SelectionMode selectionMode = SelectionMode.land;
  LandType? selectedLandType = LandType.castle;
  Courtier? selectedCourtier;

  LandType? getSelectedLandType() => selectedLandType;

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

  copyWith({
    SelectionMode? selectionMode,
    Extension? extension,
    LandType? selectedLandType,
    Courtier? selectedCourtier,
    HashSet<QuestType>? selectedQuests,
  }) => UserSelection(
    selectionMode: selectionMode ?? this.selectionMode,
    selectedLandType: selectedLandType ?? this.selectedLandType,
    selectedCourtier: selectedCourtier ?? this.selectedCourtier,
  );
}
