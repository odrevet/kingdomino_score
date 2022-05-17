import 'package:flutter/material.dart';

import '../models/land.dart';
import '../models/warning.dart';
import 'kingdomino_widget.dart';
import 'land_tile.dart';

class WarningsWidget extends StatelessWidget {
  final List<Warning>? warnings;

  const WarningsWidget({this.warnings, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tableRows = <TableRow>[];

    for (Warning warning in warnings!) {
      var tableCells = <TableCell>[];

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                warning.leftOperand.toString(),
              ))));

      tableCells.add(warning.landType == LandType.castle
          ? const TableCell(
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    castle,
                  )))
          : TableCell(
              child: Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 16.0,
                height: 16.0,
                child: LandTile(
                  landType: warning.landType,
                ),
              ),
            )));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.center,
              child: Text(
                crown * warning.crown,
              ))));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.center,
              child: Text(
                warning.operator,
              ))));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                warning.rightOperand.toString(),
              ))));

      TableRow tableRow = TableRow(children: tableCells);
      tableRows.add(tableRow);
    }

    return SingleChildScrollView(child: Table(children: tableRows));
  }
}
