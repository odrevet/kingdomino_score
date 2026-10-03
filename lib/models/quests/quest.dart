import '../kingdom.dart';
import '../land.dart' show LandType;
import 'bleak_king.dart';
import 'folie_des_grandeurs.dart';
import 'four_corners.dart';
import 'harmony.dart';
import 'local_business.dart';
import 'lost_corner.dart';
import 'middle_kingdom.dart';

export 'bleak_king.dart';
export 'folie_des_grandeurs.dart';
export 'four_corners.dart';
export 'harmony.dart';
export 'local_business.dart';
export 'lost_corner.dart';
export 'middle_kingdom.dart';
export 'quest.dart';

enum QuestType {
  harmony,
  middleKingdom,
  bleakKing,
  folieDesGrandeurs,
  fourCornersWheat,
  fourCornersLake,
  fourCornersForest,
  fourCornersGrassLand,
  fourCornersSwamp,
  fourCornersMine,
  localBusinessWheat,
  localBusinessLake,
  localBusinessForest,
  localBusinessGrassLand,
  localBusinessSwamp,
  localBusinessMine,
  lostCorner,
}

abstract class Quest {
  int reward;

  Quest({required this.reward});

  List<(int, int)> getPlaces(Kingdom kingdom);

  int getPoints(Kingdom kingdom) => reward * getPlaces(kingdom).length;
}

Quest createQuest(QuestType type) {
  switch (type) {
    case QuestType.harmony:
      return Harmony();
    case QuestType.middleKingdom:
      return MiddleKingdom();
    case QuestType.bleakKing:
      return BleakKing();
    case QuestType.folieDesGrandeurs:
      return FolieDesGrandeurs();
    case QuestType.fourCornersWheat:
      return FourCorners(LandType.wheat);
    case QuestType.fourCornersLake:
      return FourCorners(LandType.lake);
    case QuestType.fourCornersForest:
      return FourCorners(LandType.forest);
    case QuestType.fourCornersGrassLand:
      return FourCorners(LandType.grassland);
    case QuestType.fourCornersSwamp:
      return FourCorners(LandType.swamp);
    case QuestType.fourCornersMine:
      return FourCorners(LandType.mine);
    case QuestType.localBusinessWheat:
      return LocalBusiness(LandType.wheat);
    case QuestType.localBusinessLake:
      return LocalBusiness(LandType.lake);
    case QuestType.localBusinessForest:
      return LocalBusiness(LandType.forest);
    case QuestType.localBusinessGrassLand:
      return LocalBusiness(LandType.grassland);
    case QuestType.localBusinessSwamp:
      return LocalBusiness(LandType.swamp);
    case QuestType.localBusinessMine:
      return LocalBusiness(LandType.mine);
    case QuestType.lostCorner:
      return LostCorner();
  }
}

String assetsquestsLocation = 'assets/quests';

Map<QuestType, String> questPicture = {
  QuestType.harmony: 'harmony.svg',
  QuestType.middleKingdom: 'middleKingdom.svg',
  QuestType.lostCorner: 'lostCorner.svg',
  QuestType.bleakKing: 'bleakKing.svg',
  QuestType.folieDesGrandeurs: 'folieDesGrandeurs.svg',
  QuestType.fourCornersWheat: 'fourCornersWheat.svg',
  QuestType.fourCornersLake: 'fourCornersLake.svg',
  QuestType.fourCornersForest: 'fourCornersForest.svg',
  QuestType.fourCornersGrassLand: 'fourCornersGrassLand.svg',
  QuestType.fourCornersSwamp: 'fourCornersSwamp.svg',
  QuestType.fourCornersMine: 'fourCornersMine.svg',
  QuestType.localBusinessWheat: 'localBusinessWheat.svg',
  QuestType.localBusinessLake: 'localBusinessLake.svg',
  QuestType.localBusinessForest: 'localBusinessForest.svg',
  QuestType.localBusinessGrassLand: 'localBusinessGrassLand.svg',
  QuestType.localBusinessSwamp: 'localBusinessSwamp.svg',
  QuestType.localBusinessMine: 'localBusinessMine.svg',
};
