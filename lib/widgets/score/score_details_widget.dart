import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kingdomino_score_count/models/extensions/extension.dart';
import 'package:kingdomino_score_count/widgets/tile/land_tile.dart';

import '../../cubits/game_cubit.dart';
import '../../cubits/kingdom_cubit.dart';
import '../../cubits/rules_cubit.dart';
import '../../models/quests/quest.dart';
import '../kingdomino_widget.dart';

class ScoreDetailsWidget extends StatelessWidget {
  final bool showTotal;

  const ScoreDetailsWidget({this.showTotal = true, super.key});

  @override
  Widget build(BuildContext context) {
    var properties = getKingdomCubit(
      context,
      context.read<GameCubit>().state.kingColor!,
    ).state.getProperties();

    Widget content;

    properties.sort(
      (property, propertyToComp) => (property.crownCount * property.landCount)
          .compareTo(propertyToComp.crownCount * propertyToComp.landCount),
    );

    var tableRows = <TableRow>[];
    for (var property in properties) {
      var tableCells = <TableCell>[];

      tableCells.add(
        TableCell(
          child: Align(
            alignment: Alignment.center,
            child: Text('${property.landCount}'),
          ),
        ),
      );
      tableCells.add(
        TableCell(
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 16.0,
              height: 16.0,
              child: LandTile(landType: property.landType),
            ),
          ),
        ),
      );
      tableCells.add(
        const TableCell(
          child: Align(
            alignment: Alignment.center,
            child: Text('×', maxLines: 1),
          ),
        ),
      );
      tableCells.add(
        TableCell(
          child: Align(
            alignment: Alignment.center,
            child: Text(property.crownCount.toString(), maxLines: 1),
          ),
        ),
      );
      tableCells.add(
        const TableCell(
          child: Align(
            alignment: Alignment.center,
            child: Text(crown, maxLines: 1),
          ),
        ),
      );
      tableCells.add(
        const TableCell(
          child: Align(
            alignment: Alignment.center,
            child: Text('=', maxLines: 1),
          ),
        ),
      );
      tableCells.add(
        TableCell(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              '${property.landCount * property.crownCount}',
              maxLines: 1,
            ),
          ),
        ),
      );

      var tableRow = TableRow(children: tableCells);
      tableRows.add(tableRow);
    }

    //quests points
    for (var questType in context.read<RulesCubit>().state.selectedQuests) {
      var tableCells = <TableCell>[];

      tableCells.add(const TableCell(child: Text('')));
      tableCells.add(const TableCell(child: Text('')));
      tableCells.add(const TableCell(child: Text('')));
      tableCells.add(const TableCell(child: Text('')));

      tableCells.add(
        TableCell(
          child: Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              '$assetsquestsLocation/${questPicture[questType]}',
            ),
          ),
        ),
      );

      tableCells.add(
        const TableCell(
          child: Align(alignment: Alignment.center, child: Text('=')),
        ),
      );

      tableCells.add(
        TableCell(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              context
                  .read<GameCubit>()
                  .state
                  .getCurrentPlayer()!
                  .score
                  .scoreQuest[questType]
                  .toString(),
            ),
          ),
        ),
      );

      var tableRow = TableRow(children: tableCells);
      tableRows.add(tableRow);
    }

    if (context.read<RulesCubit>().state.extension == Extension.laCour) {
      var tableCells = <TableCell>[];

      tableCells.add(const TableCell(child: Text('')));
      tableCells.add(const TableCell(child: Text('')));
      tableCells.add(const TableCell(child: Text('')));
      tableCells.add(const TableCell(child: Text('')));

      tableCells.add(
        TableCell(
          child: Align(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/lacour/resource.png',
              height: 25,
              width: 25,
            ),
          ),
        ),
      );

      tableCells.add(
        const TableCell(
          child: Align(alignment: Alignment.center, child: Text('=')),
        ),
      );

      tableCells.add(
        TableCell(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              context
                  .read<GameCubit>()
                  .state
                  .getCurrentPlayer()!
                  .score
                  .scoreLacour
                  .toString(),
            ),
          ),
        ),
      );

      var tableRow = TableRow(children: tableCells);
      tableRows.add(tableRow);
    }

    //SUM
    if (context.read<GameCubit>().state.getCurrentPlayer()!.score.total > 0 &&
        showTotal == true) {
      var tableCells = <TableCell>[];

      tableCells.add(const TableCell(child: Text('')));
      tableCells.add(const TableCell(child: Text('')));
      tableCells.add(const TableCell(child: Text('')));
      tableCells.add(const TableCell(child: Text('')));
      tableCells.add(const TableCell(child: Text('')));
      tableCells.add(const TableCell(child: Text('')));

      tableCells.add(const TableCell(child: Divider(color: Colors.white)));

      var tableRow = TableRow(children: tableCells);
      tableRows.add(tableRow);

      //SUM
      var tableCellsTotal = <TableCell>[];

      tableCellsTotal.add(const TableCell(child: Text('')));
      tableCellsTotal.add(const TableCell(child: Text('')));
      tableCellsTotal.add(const TableCell(child: Text('')));
      tableCellsTotal.add(const TableCell(child: Text('')));
      tableCellsTotal.add(const TableCell(child: Text('')));
      tableCellsTotal.add(const TableCell(child: Text('')));

      tableCellsTotal.add(
        TableCell(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              context
                  .read<GameCubit>()
                  .state
                  .getCurrentPlayer()!
                  .score
                  .total
                  .toString(),
            ),
          ),
        ),
      );

      var tableRowTotal = TableRow(children: tableCellsTotal);
      tableRows.add(tableRowTotal);
    }

    content = SingleChildScrollView(child: Table(children: tableRows));

    return content;
  }
}
