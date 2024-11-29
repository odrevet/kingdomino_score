import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/cubits/kingdom_cubit.dart';
import 'package:kingdomino_score_count/models/game_set.dart';
import 'package:kingdomino_score_count/widgets/kingdomino_app_bar.dart';
import 'package:kingdomino_score_count/widgets/score/score_widget.dart';
import 'package:kingdomino_score_count/widgets/warning_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
  const KingdominoWidget({
    super.key,
  });

  @override
  State<KingdominoWidget> createState() => _KingdominoWidgetState();
}

class _KingdominoWidgetState extends State<KingdominoWidget> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  _KingdominoWidgetState();

  @override
  initState() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      _packageInfo = packageInfo;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<KingdomCubitGreen, Kingdom>(
              listener: (context, kingdom) {
            context.read<GameCubit>().calculateScore(
                KingColor.green, kingdom, context.read<RulesCubit>().state);
          }),
          BlocListener<KingdomCubitPink, Kingdom>(listener: (context, kingdom) {
            context.read<GameCubit>().calculateScore(
                KingColor.pink, kingdom, context.read<RulesCubit>().state);
          }),
          BlocListener<KingdomCubitYellow, Kingdom>(
              listener: (context, kingdom) {
            context.read<GameCubit>().calculateScore(
                KingColor.yellow, kingdom, context.read<RulesCubit>().state);
          }),
          BlocListener<KingdomCubitBlue, Kingdom>(listener: (context, kingdom) {
            context.read<GameCubit>().calculateScore(
                KingColor.blue, kingdom, context.read<RulesCubit>().state);
          }),
          BlocListener<KingdomCubitBrown, Kingdom>(
              listener: (context, kingdom) {
            context.read<GameCubit>().calculateScore(
                KingColor.brown, kingdom, context.read<RulesCubit>().state);
          })
        ],
        child: BlocBuilder<RulesCubit, Rules>(builder: (context, rules) {
          return BlocBuilder<GameCubit, Game>(builder: (context, game) {
            final kingColor = game.kingColor;
            final kingdomCubit = getKingdomCubit(context, kingColor!);

            return BlocBuilder<KingdomCubit, Kingdom>(
                bloc: kingdomCubit,
                builder: (context, kingdom) {
                  return Scaffold(
                      appBar: KingdominoAppBar(packageInfo: _packageInfo),
                      floatingActionButton:
                          game.getCurrentPlayer()!.warnings.isEmpty
                              ? null
                              : FloatingActionButton(
                                  child: Badge(
                                      label: Text(game
                                          .getCurrentPlayer()!
                                          .warnings
                                          .length
                                          .toString()),
                                      child: const Icon(Icons.warning)),
                                  onPressed: () {
                                    showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: WarningsWidget(),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Icon(
                                                Icons.done,
                                                color: Colors.black87,
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }),
                      body: OrientationBuilder(
                          builder: (orientationBuilderContext, orientation) {
                        if (orientation == Orientation.portrait) {
                          return Column(children: <Widget>[
                            // ignore: prefer_const_constructors
                            Expanded(
                              flex: 4,
                              // ignore: prefer_const_constructors
                              child: ScoreWidget(),
                            ),
                            Expanded(
                              flex: 5,
                              child: KingdomWidget(
                                kingdom: kingdom,
                              ),
                            ),
                            TileBar(
                              extension: rules.extension,
                              verticalAlign: false,
                            ),
                          ]);
                        } else {
                          return Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                // ignore: prefer_const_constructors
                                Expanded(
                                  child: ScoreWidget(),
                                ),
                                KingdomWidget(
                                  kingdom: kingdom,
                                ),
                                TileBar(
                                  extension: rules.extension,
                                  verticalAlign: true,
                                )
                              ]);
                        }
                      }));
                });
          });
        }));
  }
}
