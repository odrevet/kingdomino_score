import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/kingdom.dart';
import '../models/score.dart';

class ScoreCubit extends Cubit<Score> {
  ScoreCubit() : super(Score());

  void reset() => emit(Score());

  void calculate(Kingdom kingdom, bool lacour, selectedQuests) {
    state.updateScores(kingdom, lacour, selectedQuests);
    emit(state.copyWith());
  }
}
