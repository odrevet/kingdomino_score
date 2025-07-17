import '../kingdom.dart';

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

  int? getPoints(Kingdom kingdom);
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
