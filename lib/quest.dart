import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'kingdom.dart';
import 'kingdomWidget.dart';
import 'mainWidget.dart' show castle;
import 'quests/harmony.dart';
import 'quests/middleKingdom.dart';

const String shield = '\u{1F6E1}';
const String cross = '\u{2717}';

Widget check = Icon(MdiIcons.check, color: Colors.green);

///render a shield with point awarded in front
class QuestPointWidget extends StatelessWidget {
  final int points;

  QuestPointWidget(this.points);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 35,
          width: 35,
          child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                shield,
              )),
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
            color: Colors.white,
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
  final Widget child;

  const QuestMiniTile({this.child, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 16,
        height: 16,
        child: Container(
            decoration: BoxDecoration(
                border: child == null
                    ? null
                    : Border.all(color: Colors.grey, width: 0.3)),
            child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Container(child: child == null ? Container() : child))));
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
            : Container()),
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

class HarmonyWidget extends QuestWidget {
  final quest = Harmony();

  @override
  Widget build(BuildContext context) {
    const String rectangle = '\u{25AD}';

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

class MiddleKingdomWidget extends QuestWidget {
  final quest = MiddleKingdom();

  Widget _buildTable() {
    return Table(children: [
      TableRow(children: [
        QuestMiniTile(),
        QuestMiniTile(),
        QuestMiniTile(),
      ]),
      TableRow(children: [
        QuestMiniTile(),
        QuestMiniTile(child: check),
        QuestMiniTile(),
      ]),
      TableRow(children: [
        QuestMiniTile(),
        QuestMiniTile(),
        QuestMiniTile(),
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
