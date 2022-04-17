import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/models/extension.dart';

import '../cubits/kingdom_cubit.dart';
import '../models/land.dart';
import '../cubits/score_cubit.dart';
import 'kingdomino_widget.dart';

class ScoreDetailsWidget extends StatelessWidget {
  final groupScore;
  final quests;
  final getExtension;

  ScoreDetailsWidget({this.groupScore, this.quests, this.getExtension});

  @override
  Widget build(BuildContext context) {
    var properties = context.read<KingdomCubit>().state.getProperties();

    Widget content;

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
              child: AutoSizeText(property.crownCount.toString(),
                  maxLines: 1, group: groupScore))));
      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText(crown, maxLines: 1, group: groupScore))));
      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.center,
              child: AutoSizeText('=', maxLines: 1, group: groupScore))));
      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText('${property.landCount * property.crownCount}',
                  maxLines: 1, group: groupScore))));

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
              child: AutoSizeText('=', maxLines: 1, group: groupScore))));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText(
                  context.read<ScoreCubit>().state.scoreOfQuest.toString(),
                  maxLines: 1,
                  group: groupScore))));

      var tableRow = TableRow(children: tableCells);
      tableRows.add(tableRow);
    }

    if (getExtension() == Extension.LaCour) {
      var tableCells = <TableCell>[];

      tableCells.add(TableCell(child: AutoSizeText('')));
      tableCells.add(TableCell(child: AutoSizeText('')));
      tableCells.add(TableCell(child: AutoSizeText('')));
      tableCells.add(TableCell(child: AutoSizeText('')));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child: Image.asset(
                'assets/lacour/resource.png',
                height: 25,
                width: 25,
              ))));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.center,
              child: AutoSizeText('=', maxLines: 1, group: groupScore))));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText(
                  context.read<ScoreCubit>().state.scoreOfLacour.toString(),
                  maxLines: 1,
                  group: groupScore))));

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
            child: AutoSizeText('Σ', maxLines: 1, group: groupScore))));

    tableCells.add(TableCell(
        child: Align(
            alignment: Alignment.center,
            child: AutoSizeText('=', maxLines: 1, group: groupScore))));

    tableCells.add(TableCell(
        child: Align(
            alignment: Alignment.centerRight,
            child: AutoSizeText(
                context.read<ScoreCubit>().state.score.toString(),
                maxLines: 1,
                group: groupScore))));

    var tableRow = TableRow(children: tableCells);
    tableRows.add(tableRow);

    content = SingleChildScrollView(child: Table(children: tableRows));

    return content;
  }
}
