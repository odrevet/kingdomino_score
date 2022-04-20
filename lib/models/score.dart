import 'dart:collection';

import 'score_quest.dart';
import 'extensions/extension.dart';
import 'kingdom.dart';
import 'extensions/lacour/lacour.dart';
import 'land.dart' show LandType;

class Score {
  int scoreProperty = 0;
  int scoreOfQuest = 0;
  int scoreOfLacour = 0;
  int score = 0;

  Score(
      {this.score = 0,
      this.scoreProperty = 0,
      this.scoreOfQuest = 0,
      this.scoreOfLacour = 0});

  copyWith(
          {int? score,
          int? scoreProperty,
          int? scoreOfQuest,
          int? scoreOfLacour}) =>
      Score(
          score: score ?? this.score,
          scoreProperty: scoreProperty ?? this.scoreProperty,
          scoreOfQuest: scoreOfQuest ?? this.scoreOfQuest,
          scoreOfLacour: scoreOfLacour ?? this.scoreOfLacour);

  void updateScoreQuest(Kingdom kingdom, selectedQuests) {
    scoreOfQuest = calculateQuestScore(selectedQuests, kingdom);
  }

  int calculateLacourScore(Kingdom kingdom) {
    int scoreOfLacour = 0;
    for (int y = 0; y < kingdom.size; y++) {
      for (int x = 0; x < kingdom.size; x++) {
        Courtier? courtier = kingdom.getLand(x, y)?.courtier;
        if (courtier != null) {
          scoreOfLacour += courtier.getPoints(kingdom, x, y);
        }
      }
    }

    return scoreOfLacour;
  }

  int calculateQuestScore(HashSet<QuestType> selectedQuests, Kingdom kingdom) {
    int scoreQuest = 0;
    for (var selectedQuest in selectedQuests) {
      switch (selectedQuest) {
        case QuestType.harmony:
          {
            scoreQuest += Harmony().getPoints(kingdom)!;
          }
          break;
        case QuestType.middleKingdom:
          {
            scoreQuest += MiddleKingdom().getPoints(kingdom);
          }
          break;
        case QuestType.bleakKing:
          {
            scoreQuest += BleakKing().getPoints(kingdom);
          }
          break;
        case QuestType.folieDesGrandeurs:
          {
            scoreQuest += FolieDesGrandeurs().getPoints(kingdom);
          }
          break;
        case QuestType.fourCornersWheat:
          {
            scoreQuest += FourCorners(LandType.wheat).getPoints(kingdom);
          }
          break;
        case QuestType.fourCornersLake:
          {
            scoreQuest += FourCorners(LandType.lake).getPoints(kingdom);
          }
          break;
        case QuestType.fourCornersForest:
          {
            scoreQuest += FourCorners(LandType.forest).getPoints(kingdom);
          }
          break;
        case QuestType.fourCornersGrassLand:
          {
            scoreQuest += FourCorners(LandType.grassland).getPoints(kingdom);
          }
          break;
        case QuestType.fourCornersSwamp:
          {
            scoreQuest += FourCorners(LandType.swamp).getPoints(kingdom);
          }
          break;
        case QuestType.fourCornersMine:
          {
            scoreQuest += FourCorners(LandType.mine).getPoints(kingdom);
          }
          break;
        case QuestType.localBusinessWheat:
          {
            scoreQuest += LocalBusiness(LandType.wheat).getPoints(kingdom);
          }
          break;
        case QuestType.localBusinessLake:
          {
            scoreQuest += LocalBusiness(LandType.lake).getPoints(kingdom);
          }
          break;
        case QuestType.localBusinessForest:
          {
            scoreQuest += LocalBusiness(LandType.forest).getPoints(kingdom);
          }
          break;
        case QuestType.localBusinessGrassLand:
          {
            scoreQuest += LocalBusiness(LandType.grassland).getPoints(kingdom);
          }
          break;
        case QuestType.localBusinessSwamp:
          {
            scoreQuest += LocalBusiness(LandType.swamp).getPoints(kingdom);
          }
          break;
        case QuestType.localBusinessMine:
          {
            scoreQuest += LocalBusiness(LandType.mine).getPoints(kingdom);
          }
          break;
        case QuestType.lostCorner:
          {
            scoreQuest += LostCorner().getPoints(kingdom);
          }
          break;
      }
    }
    return scoreQuest;
  }

  void updateScoreLacour(Kingdom kingdom) {
    scoreOfLacour = calculateLacourScore(kingdom);
  }

  void updateScores(Kingdom kingdom, Extension? extension, selectedQuests) {
    _updateScoreProperty(kingdom);
    updateScoreQuest(kingdom, selectedQuests);
    if (extension == Extension.laCour) {
      updateScoreLacour(kingdom);
    }
    updateScore(extension);
  }

  void _updateScoreProperty(Kingdom kingdom) {
    var properties = kingdom.getProperties();
    scoreProperty = kingdom.calculateScoreFromProperties(properties);
  }

  void updateScore(Extension? extension) {
    score = scoreProperty + scoreOfQuest;
    if (extension == Extension.laCour) {
      score += scoreOfLacour;
    }
  }

  void resetScores() {
    score = scoreProperty = scoreOfQuest = scoreOfLacour = 0;
  }
}
