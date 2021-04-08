import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../models/kingdom.dart';
import '../models/quest.dart';
import '../models/quests/bleakKing.dart';
import '../models/quests/folie_des_grandeurs.dart';
import '../models/quests/four_corners.dart';
import '../models/quests/harmony.dart';
import '../models/quests/local_business.dart';
import '../models/quests/lost_corner.dart';
import '../models/quests/middle_kingdom.dart';
import 'kingdom_widget.dart';
import 'main_widget.dart' show castle, crown, square;

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

// AOG

class LocalBusinessWidget extends QuestWidget {
  final LocalBusiness quest;

  LocalBusinessWidget(this.quest);

  Widget _buildTable() {
    return Table(children: [
      TableRow(children: [
        QuestMiniTile(child: check),
        QuestMiniTile(child: check),
        QuestMiniTile(child: check),
      ]),
      TableRow(children: [
        QuestMiniTile(child: check),
        QuestMiniTile(child: Text(castle)),
        QuestMiniTile(child: check),
      ]),
      TableRow(children: [
        QuestMiniTile(child: check),
        QuestMiniTile(child: check),
        QuestMiniTile(child: check),
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
        QuestMiniTile(child: check),
        QuestMiniTile(),
        QuestMiniTile(child: check),
      ]),
      TableRow(children: [
        QuestMiniTile(),
        QuestMiniTile(),
        QuestMiniTile(),
      ]),
      TableRow(children: [
        QuestMiniTile(child: check),
        QuestMiniTile(),
        QuestMiniTile(child: check),
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
      Positioned(
        left: 0.0,
        bottom: 0.0,
        child: QuestMiniTile(child: check),
      )
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
        QuestMiniTile(child: check),
        QuestMiniTile(child: check),
        QuestMiniTile(),
        QuestMiniTile(child: check),
        QuestMiniTile(child: check),
        QuestMiniTile(child: check),
      ]),
      TableRow(children: [
        QuestMiniTile(child: check),
        QuestMiniTile(),
        QuestMiniTile(child: check),
        QuestMiniTile(),
        QuestMiniTile(),
        QuestMiniTile(),
      ]),
      TableRow(children: [
        QuestMiniTile(child: check),
        QuestMiniTile(),
        QuestMiniTile(),
        QuestMiniTile(child: check),
        QuestMiniTile(),
        QuestMiniTile(),
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
