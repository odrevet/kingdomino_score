import 'package:flutter/material.dart';

import 'board.dart';

const String shield = '\u{1F6E1}';

//render a shield with point awarded in front
class QuestPoint extends StatelessWidget {
  int points;

  QuestPoint(int points) {
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
  int _extraPoints; //points awarded if quest is fulfilled

  Widget build(); //visual representation of the quest

  int getPoints(Board board); //return true is quest if fulfilled
}

class Harmony extends Quest {
  int _extraPoints = 5;

  Widget build() {
    return Row(children: <Widget>[QuestPoint(_extraPoints), Text('Harmony')]);
  }

  int getPoints(Board board) {
    return board.lands
            .expand((i) => i)
            .toList()
            .where((field) => field.landType == LandType.none)
            .isEmpty
        ? _extraPoints
        : 0;
  }
}

class MiddleKingdom extends Quest {
  int _extraPoints = 10;

  Widget build() {
    return Row(
        children: <Widget>[QuestPoint(_extraPoints), Text('MiddleKingdom')]);
  }

  int getPoints(Board board) {
    int x, y;

    if (board.size == 5) {
      x = y = 2;
    } else {
      x = y = 3;
    }

    if (board.lands[x][y].landType == LandType.castle)
      return _extraPoints;
    else
      return 0;
  }
}
