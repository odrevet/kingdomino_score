import 'dart:collection';

import 'models/kingdom.dart';
import 'models/land.dart' show LandType;
import 'models/quests/bleakKing.dart';
import 'models/quests/folie_des_grandeurs.dart';
import 'models/quests/four_corners.dart';
import 'models/quests/harmony.dart';
import 'models/quests/local_business.dart';
import 'models/quests/lost_corner.dart';
import 'models/quests/middle_kingdom.dart';
import 'models/quests/quest.dart';

int calculateQuestScore(HashSet<QuestType> selectedQuests, Kingdom kingdom) {
  int scoreQuest = 0;
  selectedQuests.forEach((selectedQuest) {
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
  });
  return scoreQuest;
}
