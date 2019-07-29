import 'package:flutter/material.dart';

import 'main.dart';
import 'board.dart';
import 'quest.dart';

const Map<LandType, Map<String, dynamic>> gameSet = {
  LandType.wheat: {
    'count': 2,
    'crowns': {'max': 2}
  },
  LandType.grassland: {
    'count': 5,
    'crowns': {'max': 2}
  },
  LandType.forest: {
    'count': 3,
    'crowns': {'max': 2}
  },
  LandType.lake: {
    'count': 3,
    'crowns': {'max': 2}
  },
  LandType.swamp: {
    'count': 4,
  },
  LandType.mine: {
    'count': 3,
  }
};

// Quests
class LocalBusiness extends Quest {
  int _extraPoints = 5;

  LandType fieldType;

  LocalBusiness(this.fieldType);

  Widget build() {
    Color color = getColorForLandType(fieldType);
    return Row(children: <Widget>[
      QuestPoint(_extraPoints),
      Container(color: color, child: Text('Local Business'))
    ]);
  }

  int getPoints(Board board) {
    int castleX, castleY;

    for (var x = 0; x < board.size; x++) {
      for (var y = 0; y < board.size; y++) {
        if (board.lands[x][y].landType == LandType.castle) {
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
    if (isInBound(x, y, board.size) && board.lands[x][y].landType == fieldType)
      count++;

    x = castleX;
    y = castleY - 1;
    if (isInBound(x, y, board.size) && board.lands[x][y].landType == fieldType)
      count++;

    x = castleX + 1;
    y = castleY - 1;
    if (isInBound(x, y, board.size) && board.lands[x][y].landType == fieldType)
      count++;

    x = castleX - 1;
    y = castleY;
    if (isInBound(x, y, board.size) && board.lands[x][y].landType == fieldType)
      count++;

    x = castleX + 1;
    y = castleY;
    if (isInBound(x, y, board.size) && board.lands[x][y].landType == fieldType)
      count++;

    x = castleX - 1;
    y = castleY + 1;
    if (isInBound(x, y, board.size) && board.lands[x][y].landType == fieldType)
      count++;

    x = castleX;
    y = castleY + 1;
    if (isInBound(x, y, board.size) && board.lands[x][y].landType == fieldType)
      count++;

    x = castleX + 1;
    y = castleY + 1;
    if (isInBound(x, y, board.size) && board.lands[x][y].landType == fieldType)
      count++;

    return _extraPoints * count;
  }
}

class FourCorners extends Quest {
  int _extraPoints = 5;

  LandType fieldType;

  FourCorners(this.fieldType);

  Widget build() {
    Color color = getColorForLandType(fieldType);
    return Row(children: <Widget>[
      QuestPoint(_extraPoints),
      Container(color: color, child: Text('Four Corners'))
    ]);
  }

  int getPoints(Board board) {
    int count = 0;
    int size = board.size - 1;
    if (board.lands[0][0].landType == LandType.castle) count++;
    if (board.lands[size][0].landType == LandType.castle) count++;
    if (board.lands[0][size].landType == LandType.castle) count++;
    if (board.lands[size][size].landType == LandType.castle) count++;

    return _extraPoints * count;
  }
}

class LostCorner extends Quest {
  int _extraPoints = 20;

  LostCorner();

  Widget build() {
    return Row(
        children: <Widget>[QuestPoint(_extraPoints), Text('Lost Corner')]);
  }

  int getPoints(Board board) {
    int size = board.size - 1;
    return board.lands[0][0].landType == LandType.castle ||
            board.lands[size][0].landType == LandType.castle ||
            board.lands[0][size].landType == LandType.castle ||
            board.lands[size][size].landType == LandType.castle
        ? _extraPoints
        : 0;
  }
}

class FolieDesGrandeurs extends Quest {
  int _extraPoints = 10;

  FolieDesGrandeurs();

  Widget build() {
    return Row(children: <Widget>[
      QuestPoint(_extraPoints),
      Text('Folie des Grandeurs')
    ]);
  }

  int getPoints(Board board) {
    int count = 0;
    int size = board.size;

    for (var x = 0; x < size; x++) {
      for (var y = 0; y < size; y++) {
        if (board.lands[x][y].crowns == 0) continue;

        //check horizontally
        if ((isInBound(x + 1, y, size) && board.lands[x + 1][y].crowns > 0) &&
            (isInBound(x + 2, y, size) && board.lands[x + 2][y].crowns > 0))
          count++;

        //check vertically
        if ((isInBound(x, y + 1, size) && board.lands[x][y + 1].crowns > 0) &&
            (isInBound(x, y + 1, size) && board.lands[x][y + 2].crowns > 0))
          count++;

        //check diagonally (down right)
        if ((isInBound(x + 1, y + 1, size) &&
                board.lands[x + 1][y + 1].crowns > 0) &&
            (isInBound(x + 2, y + 2, size) &&
                board.lands[x + 2][y + 2].crowns > 0)) count++;

        //check diagonally (down left)
        if ((isInBound(x - 1, y + 1, size) &&
                board.lands[x - 1][y + 1].crowns > 0) &&
            (isInBound(x - 2, y + 2, size) &&
                board.lands[x - 2][y + 2].crowns > 0)) count++;
      }
    }

    return _extraPoints * count;
  }
}

class BleakKing extends Quest {
  int _extraPoints = 10;

  BleakKing();

  Widget build() {
    return Row(
        children: <Widget>[QuestPoint(_extraPoints), Text('Bleak King')]);
  }

  int getPoints(Board board) {
    var properties = getProperties(board);
    int count = properties
        .where((property) =>
            (property.landType == LandType.wheat ||
                property.landType == LandType.forest ||
                property.landType == LandType.grassland ||
                property.landType == LandType.lake) &&
            property.crownCount == 0 &&
            property.landCount == 5)
        .length;

    return _extraPoints * count;
  }
}
