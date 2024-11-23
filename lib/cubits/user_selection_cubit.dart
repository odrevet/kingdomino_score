import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/land.dart';
import '../models/user_selection.dart';

class UserSelectionCubit extends Cubit<UserSelection> {
  UserSelectionCubit()
      : super(UserSelection(selectionMode: SelectionMode.castle));

  void updateSelection(SelectionMode mode, LandType landType) {
    emit(state.copyWith(
      selectionMode: mode,
      selectedLandType: landType,
    ));
  }

  void setSelectionMode(SelectionMode mode) {
    emit(state.copyWith(selectionMode: mode));
  }

  void reset() => emit(UserSelection(selectionMode: SelectionMode.castle));
}
