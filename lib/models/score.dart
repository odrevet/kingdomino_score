import 'dart:collection';

import 'extensions/extension.dart';
import 'kingdom.dart';
import 'land.dart' show LandType;
import 'quests/quest.dart';

class Score {
  final int scoreProperty;
  final int scoreQuest;
  final int scoreLacour;

  const Score(
      {this.scoreProperty = 0, this.scoreQuest = 0, this.scoreLacour = 0});

  Score copyWith({int? scoreProperty, int? scoreQuest, int? scoreLacour}) =>
      Score(
          scoreProperty: scoreProperty ?? this.scoreProperty,
          scoreQuest: scoreQuest ?? this.scoreQuest,
          scoreLacour: scoreLacour ?? this.scoreLacour);

  int get total => scoreProperty + scoreQuest + scoreLacour;

  // Factory methods to create new Score instances
  static Score calculateFromKingdom(Kingdom kingdom, Extension? extension,
      HashSet<QuestType> selectedQuests) {
    final propertyScore = calculatePropertyScore(kingdom);
    final questScore = _calculateQuestScore(selectedQuests, kingdom);
    final lacourScore =
        extension == Extension.laCour ? _calculateLacourScore(kingdom) : 0;

    return Score(
        scoreProperty: propertyScore,
        scoreQuest: questScore,
        scoreLacour: lacourScore);
  }

  // Private calculation methods
  static int calculatePropertyScore(Kingdom kingdom) {
    final properties = kingdom.getProperties();
    return kingdom.calculateScoreFromProperties(properties);
  }

  static int _calculateQuestScore(
      HashSet<QuestType> selectedQuests, Kingdom kingdom) {
    int score = 0;
    for (var quest in selectedQuests) {
      score += _getQuestPoints(quest, kingdom);
    }
    return score;
  }

  static int _calculateLacourScore(Kingdom kingdom) {
    int score = 0;
    for (int y = 0; y < kingdom.size; y++) {
      for (int x = 0; x < kingdom.size; x++) {
        final courtier = kingdom.getLand(x, y)?.courtier;
        if (courtier != null) {
          score += courtier.getPoints(kingdom, x, y);
        }
      }
    }
    return score;
  }

  static int _getQuestPoints(QuestType questType, Kingdom kingdom) {
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
