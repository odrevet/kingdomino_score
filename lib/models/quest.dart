import 'dart:collection';

import 'kingdom.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

Map<QuestType, SvgPicture> questPicture = {
  QuestType.harmony: SvgPicture.asset('assets/harmony.svg'),
  QuestType.middleKingdom: SvgPicture.asset('assets/middleKingdom.svg'),
  QuestType.lostCorner: SvgPicture.asset('assets/lostCorner.svg'),
  QuestType.folieDesGrandeurs: SvgPicture.asset('assets/folieDesGrandeurs.svg'),
  QuestType.fourCornersWheat: SvgPicture.asset('assets/fourCornersWheat.svg'),
  QuestType.fourCornersLake: SvgPicture.asset('assets/fourCornersLake.svg'),
  QuestType.fourCornersForest: SvgPicture.asset('assets/fourCornersForest.svg'),
  QuestType.fourCornersGrassLand:
      SvgPicture.asset('assets/fourCornersGrassLand.svg'),
  QuestType.fourCornersSwamp: SvgPicture.asset('assets/fourCornersSwamp.svg'),
  QuestType.fourCornersMine: SvgPicture.asset('assets/fourCornersMine.svg'),
  QuestType.localBusinessWheat:
      SvgPicture.asset('assets/localBusinessWheat.svg'),
  QuestType.localBusinessLake: SvgPicture.asset('assets/localBusinessLake.svg'),
  QuestType.localBusinessForest:
      SvgPicture.asset('assets/localBusinessForest.svg'),
  QuestType.localBusinessGrassLand:
      SvgPicture.asset('assets/localBusinessGrassLand.svg'),
  QuestType.localBusinessSwamp:
      SvgPicture.asset('assets/localBusinessSwamp.svg'),
  QuestType.localBusinessMine: SvgPicture.asset('assets/localBusinessMine.svg'),
};
