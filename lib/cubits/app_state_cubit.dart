import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/app_state.dart';
import '../models/kingdom.dart';
import '../models/score.dart';
import '../models/user_selection.dart';

class AppStateCubit extends Cubit<AppState> {
  AppStateCubit()
      : super(AppState(userSelection: UserSelection(), score: Score()));

  void reset() =>
      emit(AppState(userSelection: UserSelection(), score: Score()));

  void calculateScore(Kingdom kingdom) {
    var score = Score();
    score.updateScores(kingdom, state.userSelection.extension,
        state.userSelection.getSelectedQuests());
    emit(state.copyWith(score: score));
  }
}
