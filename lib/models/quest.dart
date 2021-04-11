import 'kingdom.dart';

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
  int extraPoints; //points awarded if quest is fulfilled

  int getPoints(Kingdom kingdom);
}
