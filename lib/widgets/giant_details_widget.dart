import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../models/age_of_giants.dart';
import '../models/kingdom.dart';
import 'kingdom_widget.dart';
import 'main_widget.dart';
import 'quest.dart';

var _textStyle = TextStyle(color: Colors.black87);

class GiantsDetailsWidget extends StatelessWidget {
  final Kingdom kingdom;
  final groupScore;
  final quests;
  final scoreOfQuest;
  final score;

  GiantsDetailsWidget(
      {this.kingdom,
      this.groupScore,
      this.quests,
      this.scoreOfQuest,
      this.score});

  @override
  Widget build(BuildContext context) {
    List<Property> properties = kingdom
        .getProperties()
        .where((property) => property.giantCount > 0)
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

      int totalCrownPointLoss = 0;
      var tableRows = <TableRow>[];
      for (var property in properties) {
        int rowScore = property.landCount * property.giantCount;
        totalCrownPointLoss += rowScore;
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
                child: AutoSizeText(property.giantCount.toString(),
                    maxLines: 1, group: groupScore, style: _textStyle))));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText(giant,
                    maxLines: 1, group: groupScore, style: _textStyle))));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.center,
                child: AutoSizeText('=',
                    maxLines: 1, group: groupScore, style: _textStyle))));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText('- $rowScore',
                    maxLines: 1, group: groupScore, style: _textStyle))));

        var tableRow = TableRow(children: tableCells);
        tableRows.add(tableRow);
      }

      //quests points
      int scoreQuestWithoutGiants = 0;
      if (quests.isNotEmpty) {
        //create a temporary kingdom without giants
        for (var i = 0; i < quests.length; i++) {
          Kingdom kingdomWithoutGiants = Kingdom(kingdom.size);

          for (var x = 0; x < kingdom.size; x++) {
            for (var y = 0; y < kingdom.size; y++) {
              Land land = kingdomWithoutGiants.getLand(y, x);
              land.giants = 0;
              land.crowns = kingdom.getLand(y, x).crowns;
              land.landType = kingdom.getLand(y, x).landType;
            }
          }

          scoreQuestWithoutGiants += quests[i].getPoints(kingdomWithoutGiants);
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
                    maxLines: 1, group: groupScore, style: _textStyle))));

        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.center,
                child: AutoSizeText('=',
                    maxLines: 1, group: groupScore, style: _textStyle))));

        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText('${scoreOfQuest - scoreQuestWithoutGiants}',
                    maxLines: 1, group: groupScore, style: _textStyle))));

        var tableRow = TableRow(children: tableCells);
        tableRows.add(tableRow);
      }

      //SUM
      int totalGiantScore =
          (scoreOfQuest - scoreQuestWithoutGiants) - totalCrownPointLoss;
      var tableCells = <TableCell>[];

      tableCells.add(TableCell(child: AutoSizeText('')));
      tableCells.add(TableCell(child: AutoSizeText('')));
      tableCells.add(TableCell(child: AutoSizeText('')));
      tableCells.add(TableCell(child: AutoSizeText('')));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText('Σ' + giant,
                  maxLines: 1, group: groupScore, style: _textStyle))));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.center,
              child: AutoSizeText('=',
                  maxLines: 1, group: groupScore, style: _textStyle))));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText('$totalGiantScore',
                  maxLines: 1, group: groupScore, style: _textStyle))));

      var tableRow = TableRow(children: tableCells);
      tableRows.add(tableRow);

      //SCORE WITHOUT GIANTS
      var tableCellsTotalWithoutGiants = <TableCell>[];

      tableCellsTotalWithoutGiants.add(TableCell(child: AutoSizeText('')));
      tableCellsTotalWithoutGiants.add(TableCell(child: AutoSizeText('')));
      tableCellsTotalWithoutGiants.add(TableCell(child: AutoSizeText('')));
      tableCellsTotalWithoutGiants.add(TableCell(child: AutoSizeText('')));

      tableCellsTotalWithoutGiants.add(TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText('Σ',
                  maxLines: 1, group: groupScore, style: _textStyle))));

      tableCellsTotalWithoutGiants.add(TableCell(
          child: Align(
              alignment: Alignment.center,
              child: AutoSizeText('=',
                  maxLines: 1, group: groupScore, style: _textStyle))));

      tableCellsTotalWithoutGiants.add(TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText('${score - totalGiantScore}',
                  maxLines: 1, group: groupScore, style: _textStyle))));

      var tableRowTotalWithoutGiants =
          TableRow(children: tableCellsTotalWithoutGiants);
      tableRows.add(tableRowTotalWithoutGiants);

      content = SingleChildScrollView(child: Table(children: tableRows));
    }
    return content;
  }
}
