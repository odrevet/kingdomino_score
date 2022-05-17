import 'dart:collection';

import "package:charcode/charcode.dart";
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/models/extensions/extension.dart';
import 'package:kingdomino_score_count/widgets/land_tile.dart';

import '../cubits/kingdom_cubit.dart';
import '../cubits/score_cubit.dart';
import '../models/quests/quest.dart';
import 'kingdomino_widget.dart';

class ScoreDetailsWidget extends StatelessWidget {
  final HashSet<QuestType> quests;
  final Function getExtension;

  const ScoreDetailsWidget(
      {required this.quests, required this.getExtension, Key? key})
      : super(key: key);

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
              child: Text('${property.landCount}'))));
      tableCells.add(TableCell(
          child: Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: 16.0,
          height: 16.0,
          child: LandTile(
            landType: property.landType,
          ),
        ),
      )));
      tableCells.add(const TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child: Text('×', maxLines: 1))));
      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child: Text(property.crownCount.toString(), maxLines: 1))));
      tableCells.add(const TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child: Text(crown, maxLines: 1))));
      tableCells.add(const TableCell(
          child: Align(
              alignment: Alignment.center, child: Text('=', maxLines: 1))));
      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child: Text('${property.landCount * property.crownCount}',
                  maxLines: 1))));

      var tableRow = TableRow(children: tableCells);
      tableRows.add(tableRow);
    }

    //quests points
    if (quests.isNotEmpty) {
      var tableCells = <TableCell>[];

      tableCells.add(const TableCell(child: Text('')));
      tableCells.add(const TableCell(child: Text('')));
      tableCells.add(const TableCell(child: Text('')));
      tableCells.add(const TableCell(child: Text('')));

      tableCells.add(const TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.shield, color: Colors.white))));

      tableCells.add(const TableCell(
          child: Align(alignment: Alignment.center, child: Text('='))));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                context.read<ScoreCubit>().state.scoreOfQuest.toString(),
              ))));

      var tableRow = TableRow(children: tableCells);
      tableRows.add(tableRow);
    }

    if (getExtension() == Extension.laCour) {
      var tableCells = <TableCell>[];

      tableCells.add(const TableCell(child: Text('')));
      tableCells.add(const TableCell(child: Text('')));
      tableCells.add(const TableCell(child: Text('')));
      tableCells.add(const TableCell(child: Text('')));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child: Image.asset(
                'assets/lacour/resource.png',
                height: 25,
                width: 25,
              ))));

      tableCells.add(const TableCell(
          child: Align(alignment: Alignment.center, child: Text('='))));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                  context.read<ScoreCubit>().state.scoreOfLacour.toString()))));

      var tableRow = TableRow(children: tableCells);
      tableRows.add(tableRow);
    }

    //SUM
    var tableCells = <TableCell>[];

    tableCells.add(const TableCell(child: Text('')));
    tableCells.add(const TableCell(child: Text('')));
    tableCells.add(const TableCell(child: Text('')));
    tableCells.add(const TableCell(child: Text('')));

    tableCells.add(TableCell(
        child: Align(
            alignment: Alignment.centerRight,
            child: Text(String.fromCharCode($Sigma)))));

    tableCells.add(const TableCell(
        child: Align(alignment: Alignment.center, child: Text('='))));

    tableCells.add(TableCell(
        child: Align(
            alignment: Alignment.centerRight,
            child: Text(context.read<ScoreCubit>().state.score.toString()))));

    var tableRow = TableRow(children: tableCells);
    tableRows.add(tableRow);

    content = SingleChildScrollView(child: Table(children: tableRows));

    return content;
  }
}
