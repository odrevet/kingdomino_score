import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../models/kingdom.dart';
import 'kingdom_widget.dart';
import 'main_widget.dart';

var _textStyle = TextStyle(color: Colors.black87);

class ScoreDetailsWidget extends StatelessWidget {
  final Kingdom? kingdom;
  final groupScore;
  final quests;
  final score;
  final scoreOfQuest;

  ScoreDetailsWidget(
      {this.kingdom,
        this.groupScore,
        this.quests,
        this.score,
        this.scoreOfQuest});

  @override
  Widget build(BuildContext context) {
    var properties = kingdom!.getProperties();

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
                  maxLines: 1, group: groupScore, style: _textStyle),
            )));
        tableCells.add(TableCell(
            child: Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText(square,
                  maxLines: 1,
                  group: groupScore,
                  style: TextStyle(color: getColorForLandType(property.landType))),
            )));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText('x',
                    maxLines: 1, group: groupScore, style: _textStyle))));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText(property.crownCount.toString(),
                    maxLines: 1, group: groupScore, style: _textStyle))));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText(crown,
                    maxLines: 1, group: groupScore, style: _textStyle))));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.center,
                child: AutoSizeText('=',
                    maxLines: 1, group: groupScore, style: _textStyle))));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText(
                    '${property.landCount * property.crownCount}',
                    maxLines: 1,
                    group: groupScore,
                    style: _textStyle))));

        var tableRow = TableRow(children: tableCells);
        tableRows.add(tableRow);
      }

      //quests points
      if (quests.isNotEmpty) {
        var tableCells = <TableCell>[];

        tableCells.add(TableCell(child: AutoSizeText('')));
        tableCells.add(TableCell(child: AutoSizeText('')));
        tableCells.add(TableCell(child: AutoSizeText('')));
        tableCells.add(TableCell(child: AutoSizeText('')));

        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.shield, color: Colors.white))));

        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.center,
                child: AutoSizeText('=',
                    maxLines: 1, group: groupScore, style: _textStyle))));

        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText(scoreOfQuest.toString(),
                    maxLines: 1, group: groupScore, style: _textStyle))));

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
                  maxLines: 1, group: groupScore, style: _textStyle))));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.center,
              child: AutoSizeText('=',
                  maxLines: 1, group: groupScore, style: _textStyle))));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText(score.toString(),
                  maxLines: 1, group: groupScore, style: _textStyle))));

      var tableRow = TableRow(children: tableCells);
      tableRows.add(tableRow);

      content = SingleChildScrollView(child: Table(children: tableRows));
    }
    return content;
  }
}
