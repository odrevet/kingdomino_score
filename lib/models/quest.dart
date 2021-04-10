import 'kingdom.dart';

enum QuestType {harmony, middleKingdom, bleakKing, folieDesGrandeurs, fourCorners, localBusiness, lostCorner}  //TODO landtype

abstract class Quest {
  int extraPoints; //points awarded if quest is fulfilled

  int getPoints(Kingdom kingdom);
}