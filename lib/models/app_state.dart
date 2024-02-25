import 'package:kingdomino_score_count/models/score.dart';
import 'package:kingdomino_score_count/models/user_selection.dart';

class AppState {
  AppState({required this.userSelection, required this.score});

  Score score;
  UserSelection userSelection;

  copyWith({UserSelection? userSelection, Score? score}) => AppState(
      userSelection: userSelection ?? this.userSelection,
      score: score ?? this.score);
}
