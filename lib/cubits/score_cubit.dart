import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/kingdom.dart';
import '../models/score.dart';

class ScoreCubit extends Cubit<Score> {
  ScoreCubit() : super(Score());

  void reset() => emit(Score());

  void calculateScore(Kingdom kingdom, userSelection) {
    state.updateScores(
        kingdom, userSelection.extension, userSelection.getSelectedQuests());
    emit(state);
  }
}
