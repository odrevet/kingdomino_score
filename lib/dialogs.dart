import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'ageOfGiants.dart';
import 'kingdom.dart';
import 'kingdomWidget.dart';
import 'mainWidget.dart';
import 'quest.dart';
import 'warning.dart';

class WarningsWidget extends StatelessWidget {
  final MainWidgetState _mainWidgetState;

  WarningsWidget(this._mainWidgetState);

  @override
  Widget build(BuildContext context) {
    var tableRows = <TableRow>[];

    const double fontSize = 20.0;

    for (Warning warning in _mainWidgetState.warnings) {
      var tableCells = <TableCell>[];

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText(warning.leftOperand.toString(),
                  maxLines: 1,
                  group: _mainWidgetState.groupWarning,
                  style: TextStyle(fontSize: fontSize)))));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.center,
              child: AutoSizeText(square,
                  maxLines: 1,
                  group: _mainWidgetState.groupWarning,
                  style: TextStyle(
                      color: getColorForLandType(warning.landType))))));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.center,
              child: AutoSizeText(crown * warning.crown,
                  maxLines: 1,
                  group: _mainWidgetState.groupWarning,
                  style: TextStyle(fontSize: fontSize)))));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.center,
              child: AutoSizeText(warning.operator,
                  maxLines: 1,
                  group: _mainWidgetState.groupWarning,
                  style: TextStyle(fontSize: fontSize)))));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText(warning.rightOperand.toString(),
                  maxLines: 1,
                  group: _mainWidgetState.groupWarning,
                  style: TextStyle(fontSize: fontSize)))));

      TableRow tableRow = TableRow(children: tableCells);
      tableRows.add(tableRow);
    }

    return SingleChildScrollView(child: Table(children: tableRows));
  }
}

aboutDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: Text('Kingdomino Score',
            style: TextStyle(
                color: Colors.amber,
                fontSize: 35.0,
                fontFamily: 'Augusta',
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 3.0,
                    color: Color.fromARGB(255, 255, 255, 255),
                  )
                ])),
        content: const Text('Olivier Drevet - GPL v.3',
            style: TextStyle(fontSize: 15.0)),
        actions: <Widget>[
          FlatButton(
            child: Icon(
              Icons.done,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class ScoreDetailsWidget extends StatelessWidget {
  final MainWidgetState _mainWidgetState;

  ScoreDetailsWidget(this._mainWidgetState);

  @override
  Widget build(BuildContext context) {
    const double fontSize = 20.0;

    var properties = _mainWidgetState.kingdom.getProperties();

    Widget content;

    if (properties.isEmpty) {
      const String shrug = '\u{1F937}';
      content = Text(shrug,
          textAlign: TextAlign.center, style: TextStyle(fontSize: 50.0));
    } else {
      properties.sort((property, propertyToComp) =>
          (property.crownCount * property.landCount)
              .compareTo(propertyToComp.crownCount * propertyToComp.landCount));

      var tableRows = <TableRow>[];
      for (var property in properties) {
        var tableCells = <TableCell>[];

        tableCells.add(TableCell(
            child: Align(
          alignment: Alignment.centerRight,
          child: AutoSizeText('${property.landCount}',
              maxLines: 1,
              group: _mainWidgetState.groupScore,
              style: TextStyle(fontSize: fontSize)),
        )));
        tableCells.add(TableCell(
            child: Align(
          alignment: Alignment.centerRight,
          child: AutoSizeText(square,
              maxLines: 1,
              group: _mainWidgetState.groupScore,
              style: TextStyle(color: getColorForLandType(property.landType))),
        )));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText('x',
                    maxLines: 1,
                    group: _mainWidgetState.groupScore,
                    style: TextStyle(fontSize: fontSize)))));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText(property.crownCount.toString(),
                    maxLines: 1,
                    group: _mainWidgetState.groupScore,
                    style: TextStyle(fontSize: fontSize)))));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText(crown,
                    maxLines: 1,
                    group: _mainWidgetState.groupScore,
                    style: TextStyle(fontSize: fontSize)))));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.center,
                child: AutoSizeText('=',
                    maxLines: 1,
                    group: _mainWidgetState.groupScore,
                    style: TextStyle(fontSize: fontSize)))));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText(
                    '${property.landCount * property.crownCount}',
                    maxLines: 1,
                    group: _mainWidgetState.groupScore,
                    style: TextStyle(fontSize: fontSize)))));

        var tableRow = TableRow(children: tableCells);
        tableRows.add(tableRow);
      }

      //quests points
      if (_mainWidgetState.quests.isNotEmpty) {
        var tableCells = <TableCell>[];

        tableCells.add(TableCell(child: AutoSizeText('')));
        tableCells.add(TableCell(child: AutoSizeText('')));
        tableCells.add(TableCell(child: AutoSizeText('')));
        tableCells.add(TableCell(child: AutoSizeText('')));

        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText(shield,
                    maxLines: 1,
                    group: _mainWidgetState.groupScore,
                    style: TextStyle(fontSize: fontSize)))));

        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.center,
                child: AutoSizeText('=',
                    maxLines: 1,
                    group: _mainWidgetState.groupScore,
                    style: TextStyle(fontSize: fontSize)))));

        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText(_mainWidgetState.scoreOfQuest.toString(),
                    maxLines: 1,
                    group: _mainWidgetState.groupScore,
                    style: TextStyle(fontSize: fontSize)))));

        var tableRow = TableRow(children: tableCells);
        tableRows.add(tableRow);
      }

      //SUM
      var tableCells = <TableCell>[];

      tableCells.add(TableCell(child: AutoSizeText('')));
      tableCells.add(TableCell(child: AutoSizeText('')));
      tableCells.add(TableCell(child: AutoSizeText('')));
      tableCells.add(TableCell(child: AutoSizeText('')));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText('Σ',
                  maxLines: 1,
                  group: _mainWidgetState.groupScore,
                  style: TextStyle(fontSize: fontSize)))));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.center,
              child: AutoSizeText('=',
                  maxLines: 1,
                  group: _mainWidgetState.groupScore,
                  style: TextStyle(fontSize: fontSize)))));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText(_mainWidgetState.score.toString(),
                  maxLines: 1,
                  group: _mainWidgetState.groupScore,
                  style: TextStyle(fontSize: fontSize)))));

      var tableRow = TableRow(children: tableCells);
      tableRows.add(tableRow);

      content = SingleChildScrollView(child: Table(children: tableRows));
    }
    return content;
  }
}

class GiantsDetailsWidget extends StatelessWidget {
  final MainWidgetState _mainWidgetState;

  GiantsDetailsWidget(this._mainWidgetState);

  @override
  Widget build(BuildContext context) {
    const double fontSize = 20.0;

    List<Property> properties = _mainWidgetState.kingdom
        .getProperties()
        .where((property) => property.crownLost > 0)
        .toList();

    Widget content;

    if (properties.isEmpty) {
      const String shrug = '\u{1F937}';
      content = Text(shrug,
          textAlign: TextAlign.center, style: TextStyle(fontSize: 50.0));
    } else {
      properties.sort((property, propertyToComp) =>
          (property.crownCount * property.landCount)
              .compareTo(propertyToComp.crownCount * propertyToComp.landCount));

      int total = 0;
      var tableRows = <TableRow>[];
      for (var property in properties) {
        int rowScore = property.landCount * property.crownLost;
        total += rowScore;
        var tableCells = <TableCell>[];

        tableCells.add(TableCell(
            child: Align(
          alignment: Alignment.centerRight,
          child: AutoSizeText('${property.landCount}',
              maxLines: 1,
              group: _mainWidgetState.groupScore,
              style: TextStyle(fontSize: fontSize)),
        )));
        tableCells.add(TableCell(
            child: Align(
          alignment: Alignment.centerRight,
          child: AutoSizeText(square,
              maxLines: 1,
              group: _mainWidgetState.groupScore,
              style: TextStyle(color: getColorForLandType(property.landType))),
        )));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText('x',
                    maxLines: 1,
                    group: _mainWidgetState.groupScore,
                    style: TextStyle(fontSize: fontSize)))));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText(property.crownLost.toString(),
                    maxLines: 1,
                    group: _mainWidgetState.groupScore,
                    style: TextStyle(fontSize: fontSize)))));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText(crown + giant,
                    maxLines: 1,
                    group: _mainWidgetState.groupScore,
                    style: TextStyle(fontSize: fontSize)))));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.center,
                child: AutoSizeText('=',
                    maxLines: 1,
                    group: _mainWidgetState.groupScore,
                    style: TextStyle(fontSize: fontSize)))));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText('- $rowScore',
                    maxLines: 1,
                    group: _mainWidgetState.groupScore,
                    style: TextStyle(fontSize: fontSize)))));

        var tableRow = TableRow(children: tableCells);
        tableRows.add(tableRow);
      }

      //quests points
      int scoreQuestWithoutGiants = 0;
      if (_mainWidgetState.quests.isNotEmpty) {
        //create a temporary kingdom without giants
        for (var i = 0; i < _mainWidgetState.quests.length; i++) {
          Kingdom kingdomWithoutGiants = Kingdom(_mainWidgetState.kingdom.size);

          for (var x = 0; x < _mainWidgetState.kingdom.size; x++) {
            for (var y = 0; y < _mainWidgetState.kingdom.size; y++) {
              Land land = kingdomWithoutGiants.getLand(y, x);
              land.hasGiant = false;
              land.crowns = _mainWidgetState.kingdom.getLand(y, x).crowns;
              land.landType = _mainWidgetState.kingdom.getLand(y, x).landType;
            }
          }

          scoreQuestWithoutGiants +=
              _mainWidgetState.quests[i].getPoints(kingdomWithoutGiants);
        }

        var tableCells = <TableCell>[];

        tableCells.add(TableCell(child: AutoSizeText('')));
        tableCells.add(TableCell(child: AutoSizeText('')));
        tableCells.add(TableCell(child: AutoSizeText('')));
        tableCells.add(TableCell(child: AutoSizeText('')));

        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText(shield + giant,
                    maxLines: 1,
                    group: _mainWidgetState.groupScore,
                    style: TextStyle(fontSize: fontSize)))));

        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.center,
                child: AutoSizeText('=',
                    maxLines: 1,
                    group: _mainWidgetState.groupScore,
                    style: TextStyle(fontSize: fontSize)))));

        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText(
                    '${_mainWidgetState.scoreOfQuest - scoreQuestWithoutGiants}',
                    maxLines: 1,
                    group: _mainWidgetState.groupScore,
                    style: TextStyle(fontSize: fontSize)))));

        var tableRow = TableRow(children: tableCells);
        tableRows.add(tableRow);
      }

      //SUM
      var tableCells = <TableCell>[];

      tableCells.add(TableCell(child: AutoSizeText('')));
      tableCells.add(TableCell(child: AutoSizeText('')));
      tableCells.add(TableCell(child: AutoSizeText('')));
      tableCells.add(TableCell(child: AutoSizeText('')));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText('Σ' + giant,
                  maxLines: 1,
                  group: _mainWidgetState.groupScore,
                  style: TextStyle(fontSize: fontSize)))));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.center,
              child: AutoSizeText('=',
                  maxLines: 1,
                  group: _mainWidgetState.groupScore,
                  style: TextStyle(fontSize: fontSize)))));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText(
                  '- ${total - (_mainWidgetState.scoreOfQuest - scoreQuestWithoutGiants)}',
                  maxLines: 1,
                  group: _mainWidgetState.groupScore,
                  style: TextStyle(fontSize: fontSize)))));

      var tableRow = TableRow(children: tableCells);
      tableRows.add(tableRow);

      content = SingleChildScrollView(child: Table(children: tableRows));
    }
    return content;
  }
}
