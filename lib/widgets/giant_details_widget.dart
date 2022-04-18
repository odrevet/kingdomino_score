import 'dart:collection';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/kingdom_cubit.dart';
import '../models/age_of_giants.dart';
import '../models/land.dart';
import '../models/property.dart';
import '../models/quests/quest.dart';
import '../models/score.dart';
import 'kingdomino_widget.dart';

class GiantsDetailsWidget extends StatelessWidget {
  final AutoSizeGroup groupScore;
  final HashSet<QuestType> quests;
  final int scoreOfQuest;
  final int score;

  const GiantsDetailsWidget(
      {required this.groupScore,
      required this.quests,
      required this.scoreOfQuest,
      required this.score,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Property> properties = context
        .read<KingdomCubit>()
        .state
        .getProperties()
        .where((property) => property.giantCount > 0)
        .toList();

    Widget content;

    if (properties.isEmpty) {
      const String shrug = '\u{1F937}';
      content = const Text(shrug,
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
              maxLines: 1, group: groupScore),
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
                child: AutoSizeText('x', maxLines: 1, group: groupScore))));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText(property.giantCount.toString(),
                    maxLines: 1, group: groupScore))));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText(giant, maxLines: 1, group: groupScore))));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.center,
                child: AutoSizeText('=', maxLines: 1, group: groupScore))));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText('- $rowScore',
                    maxLines: 1, group: groupScore))));

        var tableRow = TableRow(children: tableCells);
        tableRows.add(tableRow);
      }

      //quests points
      int scoreQuestWithoutGiants = 0;
      if (quests.isNotEmpty) {
        var score = Score()
          ..calculateQuestScore(quests, context.read<KingdomCubit>().state);
        scoreQuestWithoutGiants = score.scoreOfQuest;

        var tableCells = <TableCell>[];
        tableCells.add(const TableCell(child: AutoSizeText('')));
        tableCells.add(const TableCell(child: AutoSizeText('')));
        tableCells.add(const TableCell(child: AutoSizeText('')));
        tableCells.add(const TableCell(child: AutoSizeText('')));

        tableCells.add(const TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.shield, color: Colors.white))));

        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.center,
                child: AutoSizeText('=', maxLines: 1, group: groupScore))));

        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText('${scoreOfQuest - scoreQuestWithoutGiants}',
                    maxLines: 1, group: groupScore))));

        var tableRow = TableRow(children: tableCells);
        tableRows.add(tableRow);
      }

      //SUM
      int? totalGiantScore =
          (scoreOfQuest - scoreQuestWithoutGiants) - totalCrownPointLoss;
      var tableCells = <TableCell>[];

      tableCells.add(const TableCell(child: AutoSizeText('')));
      tableCells.add(const TableCell(child: AutoSizeText('')));
      tableCells.add(const TableCell(child: AutoSizeText('')));
      tableCells.add(const TableCell(child: AutoSizeText('')));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child:
                  AutoSizeText('Σ' + giant, maxLines: 1, group: groupScore))));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.center,
              child: AutoSizeText('=', maxLines: 1, group: groupScore))));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText('$totalGiantScore',
                  maxLines: 1, group: groupScore))));

      var tableRow = TableRow(children: tableCells);
      tableRows.add(tableRow);

      //SCORE WITHOUT GIANTS
      var tableCellsTotalWithoutGiants = <TableCell>[];

      tableCellsTotalWithoutGiants
          .add(const TableCell(child: AutoSizeText('')));
      tableCellsTotalWithoutGiants
          .add(const TableCell(child: AutoSizeText('')));
      tableCellsTotalWithoutGiants
          .add(const TableCell(child: AutoSizeText('')));
      tableCellsTotalWithoutGiants
          .add(const TableCell(child: AutoSizeText('')));

      tableCellsTotalWithoutGiants.add(TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText('Σ', maxLines: 1, group: groupScore))));

      tableCellsTotalWithoutGiants.add(TableCell(
          child: Align(
              alignment: Alignment.center,
              child: AutoSizeText('=', maxLines: 1, group: groupScore))));

      tableCellsTotalWithoutGiants.add(TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText('${score - totalGiantScore}',
                  maxLines: 1, group: groupScore))));

      var tableRowTotalWithoutGiants =
          TableRow(children: tableCellsTotalWithoutGiants);
      tableRows.add(tableRowTotalWithoutGiants);

      content = SingleChildScrollView(child: Table(children: tableRows));
    }
    return content;
  }
}
