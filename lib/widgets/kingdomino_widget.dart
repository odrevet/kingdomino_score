import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/cubits/kingdom_cubit.dart';
import 'package:kingdomino_score_count/widgets/board_app_bar.dart';
import 'package:kingdomino_score_count/widgets/score/score_widget.dart';
import 'package:kingdomino_score_count/widgets/warning_widget.dart';

import '../cubits/game_cubit.dart';
import '../cubits/rules_cubit.dart';
import '../models/game.dart';
import '../models/kingdom.dart';
import '../models/rules.dart';
import 'kingdom_widget.dart';
import 'tile/tile_bar.dart';

const String crown = '\u{1F451}';
const String castle = '\u{1F3F0}';
const String square = '\u{25A0}';

class KingdominoWidget extends StatefulWidget {
  const KingdominoWidget({super.key});

  @override
  State<KingdominoWidget> createState() => _KingdominoWidgetState();
}

class _KingdominoWidgetState extends State<KingdominoWidget> {
  Widget _fixedKingdom(BuildContext context, Kingdom kingdom) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        physics: const NeverScrollableScrollPhysics(),
        overscroll: false,
        scrollbars: false,
      ),
      child: KingdomWidget(kingdom: kingdom),
    );
  }

  void _showWarnings(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          content: WarningsWidget(),
          actions: <Widget>[
            TextButton(
              child: const Icon(Icons.done, color: Colors.black87),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RulesCubit, Rules>(
      builder: (context, rules) {
        return BlocBuilder<GameCubit, Game>(
          builder: (context, game) {
            final kingdomCubit = getKingdomCubit(context, game.kingColor!);
            final warnings = game.getCurrentPlayer()!.warnings;

            return BlocBuilder<KingdomCubit, Kingdom>(
              bloc: kingdomCubit,
              builder: (context, kingdom) {
                return Scaffold(
                  appBar: BoardAppBar(),
                  body: Stack(
                    children: [
                      OrientationBuilder(
                        builder: (context, orientation) {
                          if (orientation == Orientation.portrait) {
                            return Column(
                              children: <Widget>[
                                Expanded(flex: 4, child: ScoreWidget()),
                                Expanded(
                                  flex: 5,
                                  child: _fixedKingdom(context, kingdom),
                                ),
                                TileBar(
                                  extension: rules.extension,
                                  verticalAlign: false,
                                ),
                              ],
                            );
                          }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Expanded(child: ScoreWidget()),
                              _fixedKingdom(context, kingdom),
                              TileBar(
                                extension: rules.extension,
                                verticalAlign: true,
                              ),
                            ],
                          );
                        },
                      ),
                      if (warnings.isNotEmpty)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: FloatingActionButton(
                            mini: true,
                            onPressed: () => _showWarnings(context),
                            child: Badge(
                              label: Text(warnings.length.toString()),
                              child: const Icon(Icons.warning),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}