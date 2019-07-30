import 'package:flutter/material.dart';

import 'kingdomWidget.dart';
import 'kingdom.dart';
import 'quest.dart';

const String giant = '\u{1F9D4}';

/*const Map<LandType, Map<String, dynamic>> aogSet = {
  LandType.wheat: {
    'count': 4,
    'crowns': {'max': 2, 2 : 1}
  },
  LandType.grassland: {
    'count': 5,
    'crowns': {'max': 2, 1 : 1, 2 : 1}
  },
  LandType.forest: {
    'count': 4,
    'crowns': {'max': 2, 1 : 1, 2 : 1}
  },
  LandType.lake: {
    'count': 4,
    'crowns': {'max': 2, 1 : 1, 2 : 1}
  },
  LandType.swamp: {
    'count': 4,
    'crowns': {1 : 2, 2 : 1}
  },
  LandType.mine: {
    'count': 3,
    'crowns': {1 : 1, 2 : 1}
  }
};*/

const Map<LandType, Map<String, dynamic>> gameAogSet = {
  LandType.castle: {
    'count': 1, //per player
    'crowns': {'max': 0}
  },
  LandType.wheat: {
    'count': 21 + 5 + 4,
    'crowns': {'max': 2, 1: 5, 2: 1}
  },
  LandType.grassland: {
    'count': 10 + 2 + 2 + 5,
    'crowns': {'max': 2, 1: 3, 2: 3}
  },
  LandType.forest: {
    'count': 16 + 6 + 4,
    'crowns': {'max': 2, 1: 7, 2: 1}
  },
  LandType.lake: {
    'count': 12 + 6 + 4,
    'crowns': {'max': 2, 1: 7, 2: 1}
  },
  LandType.swamp: {
    'count': 6 + 2 + 2 + 4,
    'crowns': {'max': 2, 1: 4, 2: 3}
  },
  LandType.mine: {
    'count': 1 + 1 + 3 + 1 + 3,
    'crowns': {'max': 3, 1: 2, 2: 4, 3: 1}
  }
};

// Quests
class LocalBusiness extends Quest {
  final int extraPoints = 5;

  final LandType landType;

  LocalBusiness(this.landType);

  Widget build() {
    Color color = getColorForLandType(landType);
    return Row(children: <Widget>[
      QuestPointWidget(extraPoints),
      Container(color: color, child: Text('Local Business'))
    ]);
  }

  int getPoints(Kingdom kingdom) {
    int castleX, castleY;

    for (var x = 0; x < kingdom.size; x++) {
      for (var y = 0; y < kingdom.size; y++) {
        if (kingdom.lands[x][y].landType == LandType.castle) {
          castleX = x;
          castleY = y;
          break;
        }
      }
    }

    if (castleX == null) return 0;

    int count = 0;

    int x, y;

    x = castleX - 1;
    y = castleY - 1;
    if (kingdom.isInBound(x, y) && kingdom.lands[x][y].landType == landType)
      count++;

    x = castleX;
    y = castleY - 1;
    if (kingdom.isInBound(x, y) && kingdom.lands[x][y].landType == landType)
      count++;

    x = castleX + 1;
    y = castleY - 1;
    if (kingdom.isInBound(x, y) && kingdom.lands[x][y].landType == landType)
      count++;

    x = castleX - 1;
    y = castleY;
    if (kingdom.isInBound(x, y) && kingdom.lands[x][y].landType == landType)
      count++;

    x = castleX + 1;
    y = castleY;
    if (kingdom.isInBound(x, y) && kingdom.lands[x][y].landType == landType)
      count++;

    x = castleX - 1;
    y = castleY + 1;
    if (kingdom.isInBound(x, y) && kingdom.lands[x][y].landType == landType)
      count++;

    x = castleX;
    y = castleY + 1;
    if (kingdom.isInBound(x, y) && kingdom.lands[x][y].landType == landType)
      count++;

    x = castleX + 1;
    y = castleY + 1;
    if (kingdom.isInBound(x, y) && kingdom.lands[x][y].landType == landType)
      count++;

    return extraPoints * count;
  }
}

class LocalBusinessWidget extends QuestWidget {
  final LocalBusiness quest;

  LocalBusinessWidget(this.quest);

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      QuestPointWidget(quest.extraPoints),
      Text('Local business ' + quest.landType.toString())
    ]);
  }
}

class FourCorners extends Quest {
  final int extraPoints = 5;

  LandType landType;

  FourCorners(this.landType);

  Widget build() {
    Color color = getColorForLandType(landType);
    return Row(children: <Widget>[
      QuestPointWidget(extraPoints),
      Container(color: color, child: Text('Four Corners'))
    ]);
  }

  int getPoints(Kingdom kingdom) {
    int count = 0;
    int size = kingdom.size - 1;
    if (kingdom.lands[0][0].landType == landType) count++;
    if (kingdom.lands[size][0].landType == landType) count++;
    if (kingdom.lands[0][size].landType == landType) count++;
    if (kingdom.lands[size][size].landType == landType) count++;

    return extraPoints * count;
  }
}

class FourCornersWidget extends QuestWidget {
  final FourCorners quest;

  FourCornersWidget(this.quest);

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      QuestPointWidget(quest.extraPoints),
      Text('Four Corners ' + quest.landType.toString())
    ]);
  }
}

class LostCorner extends Quest {
  final int extraPoints = 20;

  LostCorner();

  Widget build() {
    return Row(
        children: <Widget>[QuestPointWidget(extraPoints), Text('Lost Corner')]);
  }

  int getPoints(Kingdom kingdom) {
    int size = kingdom.size - 1;
    return kingdom.lands[0][0].landType == LandType.castle ||
            kingdom.lands[size][0].landType == LandType.castle ||
            kingdom.lands[0][size].landType == LandType.castle ||
            kingdom.lands[size][size].landType == LandType.castle
        ? extraPoints
        : 0;
  }
}

class LostCornerWidget extends QuestWidget {
  final Quest quest = LostCorner();

  LostCornerWidget();

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      QuestPointWidget(quest.extraPoints),
      Text('Lost Corner ')
    ]);
  }
}

///`2 different alignments cannot share more than one square`
///see https://boardgamegeek.com/thread/2040636/tic-tac-toe-bonus-challenge-tile-clarification
class FolieDesGrandeurs extends Quest {
  int extraPoints = 10;

  FolieDesGrandeurs();

  Widget build() {
    return Row(children: <Widget>[
      QuestPointWidget(extraPoints),
      Text('Folie des Grandeurs')
    ]);
  }

  int getPoints(Kingdom kingdom) {
    int count = 0;
    int size = kingdom.size;

    for (var x = 0; x < size; x++) {
      for (var y = 0; y < size; y++) {
        if (kingdom.lands[x][y].crowns == 0) continue;

        //check horizontally
        if ((kingdom.isInBound(x + 1, y) &&
                kingdom.lands[x + 1][y].crowns > 0 &&
                !kingdom.lands[x + 1][y].isMarked) &&
            (kingdom.isInBound(x + 2, y) &&
                kingdom.lands[x + 2][y].crowns > 0 &&
                !kingdom.lands[x + 2][y].isMarked)) {
          count++;
          kingdom.lands[x + 1][y].isMarked =
              kingdom.lands[x + 2][y].isMarked = true;
        }

        //check vertically
        if ((kingdom.isInBound(x, y + 1) &&
                kingdom.lands[x][y + 1].crowns > 0 &&
                !kingdom.lands[x][y + 1].isMarked) &&
            (kingdom.isInBound(x, y + 2) &&
                kingdom.lands[x][y + 2].crowns > 0 &&
                !kingdom.lands[x][y + 2].isMarked)) {
          count++;
          kingdom.lands[x][y + 1].isMarked =
              kingdom.lands[x][y + 2].isMarked = true;
        }
/*
        //check diagonally (down right)
        if ((kingdom.isInBound(x + 1, y + 1) &&
                kingdom.lands[x + 1][y + 1].crowns > 0) &&
            (kingdom.isInBound(x + 2, y + 2) &&
                kingdom.lands[x + 2][y + 2].crowns > 0)) count++;

        //check diagonally (down left)
        if ((kingdom.isInBound(x - 1, y + 1) &&
                kingdom.lands[x - 1][y + 1].crowns > 0) &&
            (kingdom.isInBound(x - 2, y + 2) &&
                kingdom.lands[x - 2][y + 2].crowns > 0)) count++;
        */
      }
    }

    //reset marked status
    kingdom.lands
        .expand((i) => i)
        .toList()
        .forEach((land) => land.isMarked = false);

    return extraPoints * count;
  }
}

class FolieDesGrandeursWidget extends QuestWidget {
  final Quest quest = FolieDesGrandeurs();

  FolieDesGrandeursWidget();

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      QuestPointWidget(quest.extraPoints),
      Text('Folie des grandeurs ')
    ]);
  }
}

/// crown covered with giant count as no crown (todo)
/// properties must be `at least` of 5 lands, as stated in the french booklet
/// todo propery with 10 or 15, ..., lands should score multiple ? 
/// see https://boardgamegeek.com/thread/2032948/bleak-king-aka-poor-mans-bonus-quest-confusion
class BleakKing extends Quest {
  int extraPoints = 10;

  BleakKing();

  Widget build() {
    return Row(
        children: <Widget>[QuestPointWidget(extraPoints), Text('Bleak King')]);
  }

  int getPoints(Kingdom kingdom) {
    var properties = kingdom.getProperties();
    int count = properties
        .where((property) =>
            (property.landType == LandType.wheat ||
                property.landType == LandType.forest ||
                property.landType == LandType.grassland ||
                property.landType == LandType.lake) &&
            property.crownCount == 0 &&
            property.landCount >= 5)
        .length;

    return extraPoints * count;
  }
}

class BleakKingWidget extends QuestWidget {
  final Quest quest = BleakKing();

  BleakKingWidget();

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      QuestPointWidget(quest.extraPoints),
      Text('Bleak King ')
    ]);
  }
}
