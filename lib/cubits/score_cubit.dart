import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/kingdom.dart';
import '../models/score.dart';

class ScoreCubit extends Cubit<Score> {
  ScoreCubit() : super(Score());

  void reset() => emit(Score());

  void calculateScore(Kingdom kingdom, rules) {
    state.updateScores(kingdom, rules.extension, rules.getSelectedQuests());
    emit(state);
  }

//void calculateScore(Kingdom kingdom) {
//  var score = Score();
//  score.updateScores(kingdom, state.rules.extension,
//      state.rules.getSelectedQuests());
//  emit(state.copyWith(score: score));
//}
}
