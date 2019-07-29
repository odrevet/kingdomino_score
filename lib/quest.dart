import 'package:flutter/material.dart';

import 'board.dart';

const String shield = '\u{1F6E1}';

//render a shield with point awarded in front
class QuestPointWidget extends StatelessWidget {
  int points;

  QuestPointWidget(int points) {
    this.points = points;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Text(
          shield,
          style: TextStyle(fontSize: 40),
        ),
        Text(points.toString())
      ],
    );
  }
}

abstract class Quest {
  int extraPoints; //points awarded if quest is fulfilled

  //Widget build(); //visual representation of the quest

  int getPoints(Board board); //return true is quest if fulfilled
}

class Harmony extends Quest {
  int extraPoints = 5;

  int getPoints(Board board) {
    return board.lands
            .expand((i) => i)
            .toList()
            .where((field) => field.landType == LandType.none)
            .isEmpty
        ? extraPoints
        : 0;
  }
}

class HarmonyWidget extends StatelessWidget {
  var quest = Harmony();

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      QuestPointWidget(quest.extraPoints),
      Text('Harmony')
    ]);
  }
}

class MiddleKingdom extends Quest {
  int extraPoints = 10;

  int getPoints(Board board) {
    int x, y;

    if (board.size == 5) {
      x = y = 2;
    } else {
      x = y = 3;
    }

    if (board.lands[x][y].landType == LandType.castle)
      return extraPoints;
    else
      return 0;
  }
}

class MiddleKingdomWidget extends StatelessWidget {
  var quest = MiddleKingdom();

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      QuestPointWidget(quest.extraPoints),
      Text('Middle Kingdom')
    ]);
  }
}