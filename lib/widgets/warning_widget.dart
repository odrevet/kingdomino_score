import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../models/warning.dart';
import 'kingdom_widget.dart';
import 'main_widget.dart';

class WarningsWidget extends StatelessWidget {
  final List<Warning>? warnings;
  final groupWarning;

  WarningsWidget({this.warnings, this.groupWarning});

  @override
  Widget build(BuildContext context) {
    var tableRows = <TableRow>[];

    for (Warning warning in warnings!) {
      var tableCells = <TableCell>[];

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText(warning.leftOperand.toString(),
                  maxLines: 1, group: groupWarning))));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.center,
              child: AutoSizeText(square,
                  maxLines: 1,
                  group: groupWarning,
                  style: TextStyle(
                      color: getColorForLandType(warning.landType))))));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.center,
              child: AutoSizeText(crown * warning.crown,
                  maxLines: 1, group: groupWarning))));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.center,
              child: AutoSizeText(warning.operator,
                  maxLines: 1, group: groupWarning))));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText(warning.rightOperand.toString(),
                  maxLines: 1, group: groupWarning))));

      TableRow tableRow = TableRow(children: tableCells);
      tableRows.add(tableRow);
    }

    return SingleChildScrollView(child: Table(children: tableRows));
  }
}



