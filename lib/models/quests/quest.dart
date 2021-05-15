import '../kingdom.dart';

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
  lostCorner
}

abstract class Quest {
  int? extraPoints; //points awarded if quest is fulfilled

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
