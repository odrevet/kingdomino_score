import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/extension.dart';
import '../models/kingdom.dart';
import '../models/score.dart';

class ScoreCubit extends Cubit<Score> {
  ScoreCubit() : super(Score());

  void reset() => emit(Score());

  void calculate(Kingdom kingdom, Extension? extension, selectedQuests) {
    state.updateScores(kingdom, extension, selectedQuests);
    emit(state.copyWith());
  }
}
