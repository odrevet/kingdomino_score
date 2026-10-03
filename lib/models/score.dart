import 'dart:collection';

import 'extensions/extension.dart';
import 'kingdom.dart';
import 'quests/quest.dart';

class Score {
  Score({
    this.scoreProperty = 0,
    this.scoreQuest = const {},
    this.scoreLacour = 0,
  });

  Score copyWith({
    int? scoreProperty,
    Map<QuestType, int>? scoreQuest,
    int? scoreLacour,
  }) => Score(
    scoreProperty: scoreProperty ?? this.scoreProperty,
    scoreQuest: scoreQuest ?? this.scoreQuest,
    scoreLacour: scoreLacour ?? this.scoreLacour,
  );

  int scoreProperty;
  Map<QuestType, int> scoreQuest;
  int scoreLacour;

  int get total =>
      scoreProperty +
      scoreLacour +
      (scoreQuest.isEmpty
          ? 0
          : scoreQuest.values.reduce((sum, score) => sum + score));

  void updateScore(
    Kingdom kingdom,
    Extension? extension,
    HashSet<QuestType> selectedQuests,
  ) {
    scoreProperty = calculatePropertyScore(kingdom);

    scoreQuest.clear();

    for (var quest in selectedQuests) {
      scoreQuest[quest] = createQuest(quest).getPoints(kingdom);
    }

    scoreLacour = extension == Extension.laCour
        ? _calculateLacourScore(kingdom)
        : 0;
  }

  int calculatePropertyScore(Kingdom kingdom) {
    final properties = kingdom.getProperties();
    return kingdom.calculateScoreFromProperties(properties);
  }

  static int _calculateLacourScore(Kingdom kingdom) {
    int score = 0;
    for (int y = 0; y < kingdom.kingdomSize.size; y++) {
      for (int x = 0; x < kingdom.kingdomSize.size; x++) {
        final courtier = kingdom.getLand(x, y)?.courtier;
        if (courtier != null) {
          score += courtier.getPoints(kingdom, x, y);
        }
      }
    }
    return score;
  }
}
