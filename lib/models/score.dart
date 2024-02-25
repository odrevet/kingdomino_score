import 'dart:collection';

import 'extensions/extension.dart';
import 'extensions/lacour/lacour.dart';
import 'kingdom.dart';
import 'land.dart' show LandType;
import 'quests/quest.dart';

class Score {
  int scoreProperty = 0;
  int scoreQuest = 0;
  int scoreLacour = 0;

  Score({this.scoreProperty = 0, this.scoreQuest = 0, this.scoreLacour = 0});

  copyWith({int? scoreProperty, int? scoreQuest, int? scoreLacour}) => Score(
      scoreProperty: scoreProperty ?? this.scoreProperty,
      scoreQuest: scoreQuest ?? this.scoreQuest,
      scoreLacour: scoreLacour ?? this.scoreLacour);

  int get total {
    return scoreProperty + scoreQuest + scoreLacour;
  }

  void updateScoreQuest(Kingdom kingdom, selectedQuests) {
    scoreQuest = calculateQuestScore(selectedQuests, kingdom);
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
    scoreLacour = calculateLacourScore(kingdom);
  }

  void updateScores(Kingdom kingdom, Extension? extension, selectedQuests) {
    _updateScoreProperty(kingdom);
    updateScoreQuest(kingdom, selectedQuests);
    if (extension == Extension.laCour) {
      updateScoreLacour(kingdom);
    }
  }

  void _updateScoreProperty(Kingdom kingdom) {
    var properties = kingdom.getProperties();
    scoreProperty = kingdom.calculateScoreFromProperties(properties);
  }

  void resetScores() {
    scoreProperty = scoreQuest = scoreLacour = 0;
  }
}
