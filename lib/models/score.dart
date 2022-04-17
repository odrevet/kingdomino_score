import '../score_quest.dart';
import 'kingdom.dart';
import 'lacour/lacour.dart';

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
        CourtierType? courtierType = kingdom.getLand(x, y)?.courtierType;
        if (courtierType != null) {
          switch (courtierType) {
            case CourtierType.farmer:
              scoreOfLacour += Farmer().getPoints(kingdom, x, y);
              break;
            case CourtierType.banker:
              scoreOfLacour += Banker().getPoints(kingdom, x, y);
              break;
            case CourtierType.lumberjack:
              scoreOfLacour += Lumberjack().getPoints(kingdom, x, y);
              break;
            case CourtierType.light_archery:
              scoreOfLacour += LightArchery().getPoints(kingdom, x, y);
              break;
            case CourtierType.fisherman:
              scoreOfLacour += Fisherman().getPoints(kingdom, x, y);
              break;
            case CourtierType.heavy_archery:
              scoreOfLacour += HeavyArchery().getPoints(kingdom, x, y);
              break;
            case CourtierType.shepherdess:
              scoreOfLacour += Shepherdess().getPoints(kingdom, x, y);
              break;
            case CourtierType.captain:
              scoreOfLacour += Captain().getPoints(kingdom, x, y);
              break;
            case CourtierType.axe_warrior:
              scoreOfLacour += AxeWarrior().getPoints(kingdom, x, y);
              break;
            case CourtierType.sword_warrior:
              scoreOfLacour += SwordWarrior().getPoints(kingdom, x, y);
              break;
            case CourtierType.king:
              scoreOfLacour += King().getPoints(kingdom, x, y);
              break;
            case CourtierType.queen:
              scoreOfLacour += Queen().getPoints(kingdom, x, y);
              break;
          }
        }
      }
    }

    return scoreOfLacour;
  }

  void updateScoreLacour(Kingdom kingdom) {
    scoreOfLacour = calculateLacourScore(kingdom);
  }

  void updateScores(Kingdom kingdom, bool lacour, selectedQuests) {
    _updateScoreProperty(kingdom);
    updateScoreQuest(kingdom, selectedQuests);
    if (lacour) {
      updateScoreLacour(kingdom);
    }
    updateScore(lacour);
  }

  void _updateScoreProperty(Kingdom kingdom) {
    var properties = kingdom.getProperties();
    scoreProperty = kingdom.calculateScoreFromProperties(properties);
  }

  void updateScore(bool lacour) {
    score = scoreProperty + scoreOfQuest;
    if (lacour) {
      score += scoreOfLacour;
    }
  }

  void resetScores() {
    score = scoreProperty = scoreOfQuest = scoreOfLacour = 0;
  }
}
