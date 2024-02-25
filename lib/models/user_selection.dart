import 'land.dart';

enum SelectionMode { land, crown, castle, giant, courtier, resource }

class UserSelection {
  UserSelection({LandType? selectedLandType}){
    setSelectedLandType(selectedLandType);
  }

  LandType? selectedLandType = LandType.castle;

  LandType? getSelectedLandType() => selectedLandType;

  setSelectedLandType(LandType? landType) {
    selectedLandType = landType;
  }

  copyWith({LandType? selectedLandType}) => UserSelection(
    selectedLandType: selectedLandType ?? this.selectedLandType,
  );
}
