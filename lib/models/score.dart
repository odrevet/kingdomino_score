import 'dart:collection';

import 'extensions/extension.dart';
import 'kingdom.dart';
import 'land.dart' show LandType;
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

    for (var quest in selectedQuests) {
      scoreQuest[quest] = _calculateQuestScore(quest, kingdom);
    }

    scoreLacour = extension == Extension.laCour
        ? _calculateLacourScore(kingdom)
        : 0;
  }

  // Private calculation methods
  int calculatePropertyScore(Kingdom kingdom) {
    final properties = kingdom.getProperties();
    return kingdom.calculateScoreFromProperties(properties);
  }

  int _calculateQuestScore(QuestType quest, Kingdom kingdom) {
    return _getQuestPoints(quest, kingdom);
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

  int _getQuestPoints(QuestType questType, Kingdom kingdom) {
    switch (questType) {
      case QuestType.harmony:
        {
          return Harmony().getPoints(kingdom)!;
        }
      case QuestType.middleKingdom:
        {
          return MiddleKingdom().getPoints(kingdom);
        }
      case QuestType.bleakKing:
        {
          return BleakKing().getPoints(kingdom);
        }
      case QuestType.folieDesGrandeurs:
        {
          return FolieDesGrandeurs().getPoints(kingdom);
        }
      case QuestType.fourCornersWheat:
        {
          return FourCorners(LandType.wheat).getPoints(kingdom);
        }
      case QuestType.fourCornersLake:
        {
          return FourCorners(LandType.lake).getPoints(kingdom);
        }
      case QuestType.fourCornersForest:
        {
          return FourCorners(LandType.forest).getPoints(kingdom);
        }
      case QuestType.fourCornersGrassLand:
        {
          return FourCorners(LandType.grassland).getPoints(kingdom);
        }
      case QuestType.fourCornersSwamp:
        {
          return FourCorners(LandType.swamp).getPoints(kingdom);
        }
      case QuestType.fourCornersMine:
        {
          return FourCorners(LandType.mine).getPoints(kingdom);
        }
      case QuestType.localBusinessWheat:
        {
          return LocalBusiness(LandType.wheat).getPoints(kingdom);
        }
      case QuestType.localBusinessLake:
        {
          return LocalBusiness(LandType.lake).getPoints(kingdom);
        }
      case QuestType.localBusinessForest:
        {
          return LocalBusiness(LandType.forest).getPoints(kingdom);
        }
      case QuestType.localBusinessGrassLand:
        {
          return LocalBusiness(LandType.grassland).getPoints(kingdom);
        }
      case QuestType.localBusinessSwamp:
        {
          return LocalBusiness(LandType.swamp).getPoints(kingdom);
        }
      case QuestType.localBusinessMine:
        {
          return LocalBusiness(LandType.mine).getPoints(kingdom);
        }
      case QuestType.lostCorner:
        {
          return LostCorner().getPoints(kingdom);
        }
    }
  }
}
