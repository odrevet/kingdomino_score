import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/cubits/domains_mode_cubit.dart';
import 'package:kingdomino_score_count/cubits/game_cubit.dart';
import 'package:kingdomino_score_count/cubits/kingdom_cubit.dart';
import 'package:kingdomino_score_count/cubits/rules_cubit.dart';
import 'package:kingdomino_score_count/models/extensions/extension.dart';
import 'package:kingdomino_score_count/models/game.dart';
import 'package:kingdomino_score_count/models/game_set.dart';
import 'package:kingdomino_score_count/models/kingdom.dart';

class BoardAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const BoardAppBar({
    this.preferredSize = const Size.fromHeight(50.0),
    super.key,
  });

  @override
  State<BoardAppBar> createState() => _BoardAppBarState();
}

class _BoardAppBarState extends State<BoardAppBar> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, Game>(
      builder: (context, game) {
        final kingColor = game.kingColor;
        final kingdomCubit = getKingdomCubit(context, kingColor!);

        return BlocBuilder<KingdomCubit, Kingdom>(
          bloc: kingdomCubit,
          builder: (context, kingdom) {
            bool hasBrownKing =
                context.read<RulesCubit>().state.extension ==
                    Extension.ageOfGiants;

            if (kingColor == KingColor.brown && !hasBrownKing) {
              context.read<GameCubit>().setPlayer(KingColor.blue);
            }

            var actions = <Widget>[
              DropdownButton<KingColor>(
                value: kingColor,
                iconSize: 25,
                iconEnabledColor: Colors.white,
                underline: Container(height: 1, color: Colors.white),
                onChanged: (player) =>
                    context.read<GameCubit>().setPlayer(player!),
                items: KingColor.values
                    .where(
                      (player) => player != KingColor.brown || hasBrownKing,
                )
                    .map<DropdownMenuItem<KingColor>>((KingColor kingColor) {
                  return DropdownMenuItem<KingColor>(
                    value: kingColor,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        kingColor.color,
                        BlendMode.srcATop,
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/king_pawn.png',
                            height: 25,
                            width: 25,
                          ),
                          Text(
                            context
                                .read<GameCubit>()
                                .state
                                .getPlayerByColor(kingColor)
                                .score
                                .total
                                .toString(),
                          ),
                        ],
                      ),
                    ),
                  );
                })
                    .toList(),
              ),
              IconButton(
                onPressed: kingdomCubit.canUndo
                    ? () {
                  kingdomCubit.undo();
                  context.read<GameCubit>().setWarnings(
                    kingdom,
                    context.read<RulesCubit>().state,
                  );
                }
                    : null,
                icon: const Icon(Icons.undo),
              ),
              IconButton(
                onPressed: kingdomCubit.canRedo
                    ? () {
                  getKingdomCubit(context, kingColor).redo();
                  context.read<GameCubit>().setWarnings(
                    kingdom,
                    context.read<RulesCubit>().state,
                  );
                }
                    : null,
                icon: const Icon(Icons.redo),
              ),
              BlocBuilder<DomainsModeCubit, bool>(
                bloc: domainsModeCubit,
                builder: (context, domainsMode) {
                  return IconButton(
                    tooltip: 'Domaines',
                    onPressed: domainsModeCubit.toggle,
                    icon: Icon(
                      Icons.border_style,
                      color: domainsMode ? Colors.amber : null,
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  getKingdomCubit(
                    context,
                    context.read<GameCubit>().state.kingColor!,
                  ).clear();
                  context.read<GameCubit>().setWarnings(
                    getKingdomCubit(
                      context,
                      context.read<GameCubit>().state.kingColor!,
                    ).state,
                    context.read<RulesCubit>().state,
                  );
                },
              ),
            ];
            return AppBar(
              titleSpacing: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: actions,
              ),
            );
          },
        );
      },
    );
  }
}