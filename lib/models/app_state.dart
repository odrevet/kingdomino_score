import 'package:kingdomino_score_count/models/score.dart';
import 'package:kingdomino_score_count/models/user_selection.dart';
import 'package:kingdomino_score_count/models/rules.dart';


class AppState {
  AppState({required this.userSelection, required this.rules, required this.score});

  Score score;
  Rules rules;
  UserSelection userSelection;

  copyWith({UserSelection? userSelection, Rules? rules, Score? score}) => AppState(
      userSelection: userSelection ?? this.userSelection,
      rules: rules ?? this.rules,
      score: score ?? this.score);
}
