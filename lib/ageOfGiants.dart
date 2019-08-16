import 'package:flutter/material.dart';

import 'kingdom.dart';
import 'kingdomWidget.dart';
import 'main.dart' show castle, crown, square;
import 'quest.dart';
import 'quests/folieDesGrandeurs.dart';
import 'quests/bleakKing.dart';
import 'quests/fourCorners.dart';
import 'quests/localBusiness.dart';
import 'quests/lostCorner.dart';


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
        QuestMiniTile(Text(castle)),
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


class LostCornerWidget extends QuestWidget {
  final Quest quest = LostCorner();

  LostCornerWidget();

  Widget _buildTable() {
    return Stack(children: [
      Container(),
      Positioned(left: 0.0, bottom: 0.0, child: QuestMiniTile(check),)
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
