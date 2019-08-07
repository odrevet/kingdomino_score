import 'package:flutter/material.dart';

import 'main.dart' show castle;
import 'kingdom.dart';
import 'kingdomWidget.dart';

const String shield = '\u{1F6E1}';
const String check = '\u{2713}';

///render a shield with point awarded in front
class QuestPointWidget extends StatelessWidget {
  final int points;

  QuestPointWidget(this.points);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Text(
          shield,
          style: TextStyle(fontSize: 40),
        ),
        Positioned.fill(
          child: Align(
              alignment: Alignment.center,
              child: Text(points.toString(), style: TextStyle(fontSize: 20.0))),
        )
      ],
    );
  }
}

///render the mini kingdom on the right side of some quest tiles
class QuestMiniKingdom extends StatelessWidget {
  const QuestMiniKingdom({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50.0,
        width: 50.0,
        child: child,
        decoration: BoxDecoration(
            border: Border(
          right: BorderSide(width: 2.0, color: Colors.grey),
          top: BorderSide(width: 2.0, color: Colors.grey),
          left: BorderSide(width: 2.0, color: Colors.blueGrey),
          bottom: BorderSide(width: 2.0, color: Colors.blueGrey),
        )));
  }
}

///to render a square in the right side table of a quest tile
class QuestMiniTile extends StatelessWidget {
  final String text;
  const QuestMiniTile(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.grey, width: 0.3)),
        child:
            Text(text, style: TextStyle(fontSize: 10.0, color: Colors.green)));
  }
}

///to render the land on the left side of a quest tile
Widget landWidget(LandType landType, [double size = 50.0]) {
  return Container(
      child: Container(
    height: size,
    width: size,
    child: Container(
        color: getColorForLandType(landType),
        child: landType == LandType.castle
            ? FittedBox(fit: BoxFit.fitWidth, child: Text(castle))
            : Text('')),
  ));
}

abstract class Quest {
  int extraPoints; //points awarded if quest is fulfilled

  int getPoints(Kingdom kingdom);
}

abstract class QuestWidget extends StatelessWidget {
  final Quest quest;

  const QuestWidget({
    Key key,
    this.quest,
  }) : super(key: key);
}

class Harmony extends Quest {
  int extraPoints = 5;

  int getPoints(Kingdom kingdom) {
    return kingdom
            .getLands()
            .expand((i) => i)
            .toList()
            .where((land) => land.landType == LandType.none)
            .isEmpty
        ? extraPoints
        : 0;
  }
}

class HarmonyWidget extends QuestWidget {
  final quest = Harmony();

  @override
  Widget build(BuildContext context) {
    const String rectangle = '\u{25AD}';
    const String cross = '\u{2717}';

    return Row(children: <Widget>[
      QuestPointWidget(quest.extraPoints),
      Stack(children: [
        Text(rectangle, style: TextStyle(fontSize: 40)),
        Text(cross, style: TextStyle(fontSize: 40, color: Colors.red))
      ]),
      Icon(Icons.delete)
    ]);
  }
}

class MiddleKingdom extends Quest {
  final int extraPoints = 10;

  int getPoints(Kingdom kingdom) {
    int x, y;

    if (kingdom.size == 5) {
      x = y = 2;
    } else {
      x = y = 3;
    }

    if (kingdom.getLand(x, y).landType == LandType.castle)
      return extraPoints;
    else
      return 0;
  }
}

class MiddleKingdomWidget extends QuestWidget {
  final quest = MiddleKingdom();

  Widget _buildTable() {
    return Table(children: [
      TableRow(children: [
        Text(' '),
        Text(' '),
        Text(' '),
      ]),
      TableRow(children: [
        Text(' '),
        QuestMiniTile(check),
        Text(' '),
      ]),
      TableRow(children: [
        Text(' '),
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
