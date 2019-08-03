import 'package:flutter/material.dart';

import 'kingdom.dart';
import 'kingdomWidget.dart';
import 'quest.dart';
import 'main.dart' show castle, crown, square;

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

  Widget _buildTable() {
    return Container(
        constraints: BoxConstraints(
            maxHeight: 50.0, maxWidth: 50.0, minWidth: 50.0, minHeight: 50.0),
        child: Table(
            //border: TableBorder.all(width: 0.1, color: Colors.grey),
            children: [
              TableRow(children: [
                QuestMiniTile(check),
                QuestMiniTile(check),
                QuestMiniTile(check),
              ]),
              TableRow(children: [
                QuestMiniTile(check),
                QuestMiniTile(castle),
                QuestMiniTile(check),
              ]),
              TableRow(children: [
                QuestMiniTile(check),
                QuestMiniTile(check),
                QuestMiniTile(check),
              ]),
            ]));
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Stack(children: [
        landWidget(quest.landType),
        QuestPointWidget(quest.extraPoints)
      ]),
      QuestMiniKingdom(child: _buildTable())
    ]);
  }
}

class FourCorners extends Quest {
  final int extraPoints = 5;

  LandType landType;

  FourCorners(this.landType);

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

  Widget _buildTable() {
    return Container(
        constraints: BoxConstraints(
            maxHeight: 50.0, maxWidth: 50.0, minWidth: 50.0, minHeight: 50.0),
        child: Table(
            children: [
              TableRow(children: [
                QuestMiniTile(check),
                Text(' '),
                QuestMiniTile(check),
              ]),
              TableRow(children: [
                Text(' '),
                Text(' '),
                Text(' '),
              ]),
              TableRow(children: [
                QuestMiniTile(check),
                Text(' '),
                QuestMiniTile(check),
              ]),
            ]));
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Stack(children: [
        landWidget(quest.landType),
        QuestPointWidget(quest.extraPoints)
      ]),
      QuestMiniKingdom(child:_buildTable())
    ]);
  }
}

class LostCorner extends Quest {
  final int extraPoints = 20;

  LostCorner();

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

  Widget _buildTable() {
    return Container(
        constraints: BoxConstraints(
            maxHeight: 50.0, maxWidth: 50.0, minWidth: 50.0, minHeight: 50.0),
        child: Table(
            children: [
              TableRow(children: [
                Text(' '),
                Text(' '),
                Text(' '),
              ]),
              TableRow(children: [
                Text(' '),
                Text(' '),
                Text(' '),
              ]),
              TableRow(children: [
                QuestMiniTile(check),
                Text(' '),
                Text(' '),
              ]),
            ]));
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Stack(children: [
        landWidget(LandType.castle),
        QuestPointWidget(quest.extraPoints)
      ]),
      QuestMiniKingdom(child:_buildTable())
    ]);
  }
}

///`2 different alignments cannot share more than one square`
///see https://boardgamegeek.com/thread/2040636/tic-tac-toe-bonus-challenge-tile-clarification
class FolieDesGrandeurs extends Quest {
  int extraPoints = 10;

  FolieDesGrandeurs();

  ///return true is 3 crowns are aligned
  ///in this case, will also set isMarked flag of checked lands to true
  bool _hasMatch(int x1, int y1, int x2, int y2, Kingdom kingdom) {
    if ((kingdom.isInBound(x1, y1) &&
            kingdom.lands[x1][y1].getCrowns() > 0 &&
            !kingdom.lands[x1][y1].isMarked) &&
        (kingdom.isInBound(x2, y2) &&
            kingdom.lands[x2][y2].getCrowns() > 0 &&
            !kingdom.lands[x2][y2].isMarked)) {
      kingdom.lands[x1][y1].isMarked = true;
      kingdom.lands[x2][y2].isMarked = true;
      return true;
    }
    return false;
  }

  int getPoints(Kingdom kingdom) {
    int count = 0;
    int size = kingdom.size;

    for (var x = 0; x < size; x++) {
      for (var y = 0; y < size; y++) {
        if (kingdom.lands[x][y].getCrowns() == 0) continue;

        //check horizontally
        if (_hasMatch(x + 1, y, x + 2, y, kingdom)) count++;

        //check vertically
        if (_hasMatch(x, y + 1, x, y + 2, kingdom)) count++;

        //check diagonally (down right)
        if (_hasMatch(x + 1, y + 1, x + 2, y + 2, kingdom)) count++;

        //check diagonally (down left)
        if (_hasMatch(x - 1, y + 1, x - 2, y + 2, kingdom)) count++;
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

  Widget _buildTable() {
    return Container(
        constraints: BoxConstraints(
            maxHeight: 50.0, maxWidth: 50.0, minWidth: 50.0, minHeight: 50.0),
        child: Table(
            children: [
              TableRow(children: [
                QuestMiniTile(check),
                QuestMiniTile(check),
                Text(' '),
                QuestMiniTile(check),
                QuestMiniTile(check),
                QuestMiniTile(check),
              ]),
              TableRow(children: [
                QuestMiniTile(check),
                Text(' '),
                QuestMiniTile(check),
                Text(' '),
                Text(' '),
                Text(' '),
              ]),
              TableRow(children: [
                QuestMiniTile(check),
                Text(' '),
                Text(' '),
                QuestMiniTile(check),
                Text(' '),
                Text(' '),
              ]),
            ]));
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(crown, style: TextStyle(fontSize: 25.0)),
            QuestPointWidget(quest.extraPoints)
          ]),
      QuestMiniKingdom(child:_buildTable())
    ]);
  }
}

/// crown covered with giant count as no crown
/// properties must be `at least` of 5 lands, as stated in the french booklet
/// see https://boardgamegeek.com/thread/2032948/bleak-king-aka-poor-mans-bonus-quest-confusion
class BleakKing extends Quest {
  int extraPoints = 10;

  BleakKing();

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
      Text(crown, style: TextStyle(fontSize: 30.0)),
      Column(
        children: <Widget>[
          SizedBox(
              height: 14.0,
              child: Row(children: [
                Text('$square',
                    style:
                        TextStyle(color: getColorForLandType(LandType.wheat))),
                Text('x 5')
              ])),
          SizedBox(
              height: 14.0,
              child: Row(children: [
                Text('$square',
                    style:
                        TextStyle(color: getColorForLandType(LandType.forest))),
                Text('x 5')
              ])),
          SizedBox(
              height: 14.0,
              child: Row(children: [
                Text('$square',
                    style: TextStyle(
                        color: getColorForLandType(LandType.grassland))),
                Text('x 5')
              ])),
          SizedBox(
              height: 14.0,
              child: Row(children: [
                Text('$square',
                    style:
                        TextStyle(color: getColorForLandType(LandType.lake))),
                Text('x 5')
              ])),
        ],
      )
    ]);
  }
}