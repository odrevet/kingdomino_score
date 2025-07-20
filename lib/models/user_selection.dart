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

  void setSelectionMode(SelectionMode selectionMode) {
    this.selectionMode = selectionMode;
  }

  SelectionMode getSelectionMode() => selectionMode;

  void setSelectedLandType(LandType? landType) {
    selectedLandType = landType;
  }

  void setSelectedCourtier(Courtier courtier) {
    selectedCourtier = courtier;
  }

  UserSelection copyWith({
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
