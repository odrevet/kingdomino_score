import 'package:flutter/material.dart';

import 'main.dart';
import 'board.dart';
import 'quest.dart';

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
    'crowns': {'max': 2, 1: 5, 2 : 1}
  },
  LandType.grassland: {
    'count': 10 + 2 + 2 + 5,
    'crowns': {'max': 2, 1: 3, 2: 3}
  },
  LandType.forest: {
    'count': 16 + 6 + 4,
    'crowns': {'max': 2, 1: 7, 2 : 1}
  },
  LandType.lake: {
    'count': 12 + 6 + 4,
    'crowns': {'max': 2, 1: 7, 2 : 1}
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
  int extraPoints = 5;

  LandType landType;

  LocalBusiness(this.landType);

  Widget build() {
    Color color = getColorForLandType(landType);
    return Row(children: <Widget>[
      QuestPointWidget(extraPoints),
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
    if (isInBound(x, y, board.size) && board.lands[x][y].landType == landType)
      count++;

    x = castleX;
    y = castleY - 1;
    if (isInBound(x, y, board.size) && board.lands[x][y].landType == landType)
      count++;

    x = castleX + 1;
    y = castleY - 1;
    if (isInBound(x, y, board.size) && board.lands[x][y].landType == landType)
      count++;

    x = castleX - 1;
    y = castleY;
    if (isInBound(x, y, board.size) && board.lands[x][y].landType == landType)
      count++;

    x = castleX + 1;
    y = castleY;
    if (isInBound(x, y, board.size) && board.lands[x][y].landType == landType)
      count++;

    x = castleX - 1;
    y = castleY + 1;
    if (isInBound(x, y, board.size) && board.lands[x][y].landType == landType)
      count++;

    x = castleX;
    y = castleY + 1;
    if (isInBound(x, y, board.size) && board.lands[x][y].landType == landType)
      count++;

    x = castleX + 1;
    y = castleY + 1;
    if (isInBound(x, y, board.size) && board.lands[x][y].landType == landType)
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
  int extraPoints = 5;

  LandType landType;

  FourCorners(this.landType);

  Widget build() {
    Color color = getColorForLandType(landType);
    return Row(children: <Widget>[
      QuestPointWidget(extraPoints),
      Container(color: color, child: Text('Four Corners'))
    ]);
  }

  int getPoints(Board board) {
    int count = 0;
    int size = board.size - 1;
    if (board.lands[0][0].landType == landType) count++;
    if (board.lands[size][0].landType == landType) count++;
    if (board.lands[0][size].landType == landType) count++;
    if (board.lands[size][size].landType == landType) count++;

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
  int extraPoints = 20;

  LostCorner();

  Widget build() {
    return Row(
        children: <Widget>[QuestPointWidget(extraPoints), Text('Lost Corner')]);
  }

  int getPoints(Board board) {
    int size = board.size - 1;
    return board.lands[0][0].landType == LandType.castle ||
            board.lands[size][0].landType == LandType.castle ||
            board.lands[0][size].landType == LandType.castle ||
            board.lands[size][size].landType == LandType.castle
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

class FolieDesGrandeurs extends Quest {
  int extraPoints = 10;

  FolieDesGrandeurs();

  Widget build() {
    return Row(children: <Widget>[
      QuestPointWidget(extraPoints),
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
            (isInBound(x, y + 2, size) && board.lands[x][y + 2].crowns > 0))
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

class BleakKing extends Quest {
  int extraPoints = 10;

  BleakKing();

  Widget build() {
    return Row(
        children: <Widget>[QuestPointWidget(extraPoints), Text('Bleak King')]);
  }

  int getPoints(Board board) {
    var properties = board.getProperties();
    int count = properties
        .where((property) =>
            (property.landType == LandType.wheat ||
                property.landType == LandType.forest ||
                property.landType == LandType.grassland ||
                property.landType == LandType.lake) &&
            property.crownCount == 0 &&
            property.landCount == 5)
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
