import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/game.dart';
import '../models/kingdom.dart';
import '../models/score.dart';

class ScoreCubit extends Cubit<Score> {
  ScoreCubit() : super(const Score());

  void reset() {
    emit(const Score());
  }

  void calculateScore(Kingdom kingdom, Game rules) {
    final newScore = Score.calculateFromKingdom(
        kingdom, rules.extension, rules.getSelectedQuests());
    emit(newScore);
  }
}
