import 'dart:math';
import 'package:flutter/material.dart';

import 'kingdom.dart';
import 'kingdomWidget.dart';
import 'main.dart' show castle, crown, square;
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

  int getPoints(Kingdom kingdom) {
    int castleX, castleY;

    for (var x = 0; x < kingdom.size; x++) {
      for (var y = 0; y < kingdom.size; y++) {
        if (kingdom.getLand(x, y).landType == LandType.castle) {
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
    if (kingdom.isInBound(x, y) && kingdom.getLand(x, y).landType == landType)
      count++;

    x = castleX;
    y = castleY - 1;
    if (kingdom.isInBound(x, y) && kingdom.getLand(x, y).landType == landType)
      count++;

    x = castleX + 1;
    y = castleY - 1;
    if (kingdom.isInBound(x, y) && kingdom.getLand(x, y).landType == landType)
      count++;

    x = castleX - 1;
    y = castleY;
    if (kingdom.isInBound(x, y) && kingdom.getLand(x, y).landType == landType)
      count++;

    x = castleX + 1;
    y = castleY;
    if (kingdom.isInBound(x, y) && kingdom.getLand(x, y).landType == landType)
      count++;

    x = castleX - 1;
    y = castleY + 1;
    if (kingdom.isInBound(x, y) && kingdom.getLand(x, y).landType == landType)
      count++;

    x = castleX;
    y = castleY + 1;
    if (kingdom.isInBound(x, y) && kingdom.getLand(x, y).landType == landType)
      count++;

    x = castleX + 1;
    y = castleY + 1;
    if (kingdom.isInBound(x, y) && kingdom.getLand(x, y).landType == landType)
      count++;

    return extraPoints * count;
  }
}

class LocalBusinessWidget extends QuestWidget {
  final LocalBusiness quest;

  LocalBusinessWidget(this.quest);

  Widget _buildTable() {
    return Table(children: [
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
    ]);
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
    if (kingdom.getLand(0, 0).landType == landType) count++;
    if (kingdom.getLand(size, 0).landType == landType) count++;
    if (kingdom.getLand(0, size).landType == landType) count++;
    if (kingdom.getLand(size, size).landType == landType) count++;

    return extraPoints * count;
  }
}

class FourCornersWidget extends QuestWidget {
  final FourCorners quest;

  FourCornersWidget(this.quest);

  Widget _buildTable() {
    return Table(children: [
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
    ]);
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

class LostCorner extends Quest {
  final int extraPoints = 20;

  LostCorner();

  int getPoints(Kingdom kingdom) {
    int size = kingdom.size - 1;
    return kingdom.getLand(0, 0).landType == LandType.castle ||
            kingdom.getLand(size, 0).landType == LandType.castle ||
            kingdom.getLand(0, size).landType == LandType.castle ||
            kingdom.getLand(size, size).landType == LandType.castle
        ? extraPoints
        : 0;
  }
}

class LostCornerWidget extends QuestWidget {
  final Quest quest = LostCorner();

  LostCornerWidget();

  Widget _buildTable() {
    return Table(children: [
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
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Stack(children: [
        landWidget(LandType.castle),
        QuestPointWidget(quest.extraPoints)
      ]),
      QuestMiniKingdom(child: _buildTable())
    ]);
  }
}

///`2 different alignments cannot share more than one square`
///see https://boardgamegeek.com/thread/2040636/tic-tac-toe-bonus-challenge-tile-clarification
class CrownAlignment {
  int x0, y0;
  int x1, y1;
  int x2, y2;

  CrownAlignment(this.y0, this.x0, this.y1, this.x1, this.y2, this.x2);
}

class FolieDesGrandeurs extends Quest {
  int extraPoints = 10;

  FolieDesGrandeurs();

  ///check if land at coord is in bound and has at least a crown
  bool _checkLandBoundAndCrown(int y, int x, Kingdom kingdom) {
    return kingdom.isInBound(x, y) && kingdom.getLand(y, x).getCrowns() > 0;
  }

  // for every land listed has at least a crown
  bool _hasCrownAlignment(
      int y0, int x0, int y1, int x1, int y2, int x2, Kingdom kingdom) {
    return _checkLandBoundAndCrown(y0, x0, kingdom) &&
        _checkLandBoundAndCrown(y1, x1, kingdom) &&
        _checkLandBoundAndCrown(y2, x2, kingdom);
  }

  void _addCrownAlignmentVertical(
      List<CrownAlignment> crownAlignment, int y, int x, Kingdom kingdom) {
    int x1 = x;
    int y1 = y + 1;
    int x2 = x;
    int y2 = y + 2;
    if (_hasCrownAlignment(y, x, y1, x1, y2, x2, kingdom))
      crownAlignment.add(CrownAlignment(y, x, y1, x1, y2, x2));
  }

  void _addCrownAlignmentHorizontal(
      List<CrownAlignment> crownAlignment, int y, int x, Kingdom kingdom) {
    int x1 = x + 1;
    int y1 = y;
    int x2 = x + 2;
    int y2 = y;
    if (_hasCrownAlignment(y, x, y1, x1, y2, x2, kingdom))
      crownAlignment.add(CrownAlignment(y, x, y1, x1, y2, x2));
  }

  void _addCrownAlignmentDiagonalRight(
      List<CrownAlignment> crownAlignment, int y, int x, Kingdom kingdom) {
    int x1 = x + 1;
    int y1 = y + 1;
    int x2 = x + 2;
    int y2 = y + 2;
    if (_hasCrownAlignment(y, x, y1, x1, y2, x2, kingdom))
      crownAlignment.add(CrownAlignment(y, x, y1, x1, y2, x2));
  }

  void _addCrownAlignmentDiagonalLeft(
      List<CrownAlignment> crownAlignment, int x, int y, Kingdom kingdom) {
    int x1 = x - 1;
    int y1 = y + 1;
    int x2 = x - 2;
    int y2 = y + 2;
    if (_hasCrownAlignment(y, x, y1, x1, y2, x2, kingdom))
      crownAlignment.add(CrownAlignment(y, x, y1, x1, y2, x2));
  }

  int _countSharedSquare(
      List<List<int>> placedAlignments, CrownAlignment crownAlignment) {
    int sharedSquareCount = 0;
    if (placedAlignments[crownAlignment.x0][crownAlignment.y0] > 1)
      sharedSquareCount++;

    if (placedAlignments[crownAlignment.x1][crownAlignment.y1] > 1)
      sharedSquareCount++;

    if (placedAlignments[crownAlignment.x2][crownAlignment.y2] > 1)
      sharedSquareCount++;

    return sharedSquareCount;
  }

  int countValidAlignments(
      List<CrownAlignment> allAlignments, Kingdom kingdom) {
    //count for every land how many square crosses
    List<List<int>> placedAlignments = [];
    for (var i = 0; i < kingdom.size; i++) {
      placedAlignments.add(List<int>.generate(kingdom.size, (_) => 0));
    }

    //do not keep alignments that have more than one shared square with another
    //alignment, and do not keep an alignment if an other alignment will share
    //more than one square when the said alignment would be place
    List<CrownAlignment> resultAlignments = List();

    allAlignments.forEach((anAlignment) {
      //add this alignment to the placedAlignments
      placedAlignments[anAlignment.x0][anAlignment.y0]++;
      placedAlignments[anAlignment.x1][anAlignment.y1]++;
      placedAlignments[anAlignment.x2][anAlignment.y2]++;

      bool validAlignment = true;

      //check if more than one shared square for the alignment being checked
      int sharedSquareCount = _countSharedSquare(placedAlignments, anAlignment);

      if (sharedSquareCount > 1) {
        //remove this alignment from the placedAlignments
        placedAlignments[anAlignment.x0][anAlignment.y0]--;
        placedAlignments[anAlignment.x1][anAlignment.y1]--;
        placedAlignments[anAlignment.x2][anAlignment.y2]--;
        validAlignment = false;
      } else {
        //check if more than one shared square with already placed squares
        for (var aResultAlignment in resultAlignments) {
          int sharedSquareCount =
              _countSharedSquare(placedAlignments, aResultAlignment);

          if (sharedSquareCount > 1) {
            //remove this alignment from the placedAlignments
            placedAlignments[anAlignment.x0][anAlignment.y0]--;
            placedAlignments[anAlignment.x1][anAlignment.y1]--;
            placedAlignments[anAlignment.x2][anAlignment.y2]--;
            validAlignment = false;
            break;
          }
        }
      }

      if (validAlignment) resultAlignments.add(anAlignment);
    });

    return resultAlignments.length;
  }

  int getPoints(Kingdom kingdom) {
    int size = kingdom.size;

    //get every alignments, regardless of shared squares
    List<CrownAlignment> alignmentVertical = List();
    List<CrownAlignment> alignmentHorizontal = List();
    List<CrownAlignment> alignmentDiagonalRight = List();
    List<CrownAlignment> alignmentDiagonalLeft = List();

    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        _addCrownAlignmentVertical(alignmentVertical, y, x, kingdom);
      }
    }

    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        _addCrownAlignmentHorizontal(alignmentHorizontal, y, x, kingdom);
      }
    }

    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        _addCrownAlignmentDiagonalRight(alignmentDiagonalRight, y, x, kingdom);
      }
    }

    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        _addCrownAlignmentDiagonalLeft(alignmentDiagonalLeft, y, x, kingdom);
      }
    }

    //sometimes check in for diagonals first gets more points and sometime
    //less. Try different strategies and retain the one that scores the most
    List<int> validAlignments = [];

    validAlignments.add(countValidAlignments([
      ...alignmentVertical,
      ...alignmentHorizontal,
      ...alignmentDiagonalRight,
      ...alignmentDiagonalLeft
    ], kingdom));

    validAlignments.add(countValidAlignments([
      ...alignmentHorizontal,
      ...alignmentVertical,
      ...alignmentDiagonalRight,
      ...alignmentDiagonalLeft
    ], kingdom));

    validAlignments.add(countValidAlignments([
      ...alignmentDiagonalRight,
      ...alignmentDiagonalLeft,
      ...alignmentVertical,
      ...alignmentHorizontal
    ], kingdom));

    validAlignments.add(countValidAlignments([
      ...alignmentDiagonalLeft,
      ...alignmentDiagonalRight,
      ...alignmentVertical,
      ...alignmentHorizontal
    ], kingdom));

    return extraPoints * validAlignments.reduce(max);
  }
}

class FolieDesGrandeursWidget extends QuestWidget {
  final Quest quest = FolieDesGrandeurs();

  FolieDesGrandeursWidget();

  Widget _buildTable() {
    return Table(children: [
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
    ]);
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
      QuestMiniKingdom(child: _buildTable())
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
      Stack(children: <Widget>[
        Text(crown, style: TextStyle(fontSize: 30.0)),
        Positioned.fill(
          child: Align(
              alignment: Alignment.center,
              child: Text(cross,
                  style: TextStyle(color: Colors.red, fontSize: 30.0))),
        )
      ]),
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
