import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/cubits/game_cubit.dart';
import 'package:kingdomino_score_count/cubits/kingdom_cubit.dart';
import 'package:kingdomino_score_count/cubits/rules_cubit.dart';
import 'package:kingdomino_score_count/models/extensions/extension.dart';
import 'package:kingdomino_score_count/models/game.dart';
import 'package:kingdomino_score_count/models/game_set.dart';
import 'package:kingdomino_score_count/models/kingdom.dart';
import 'package:kingdomino_score_count/models/rules.dart';
import 'package:kingdomino_score_count/widgets/global_menu_app_bar.dart';
import 'package:kingdomino_score_count/widgets/kingdom_preview_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'kingdomino_widget.dart';

class GlobalMenuWidget extends StatefulWidget {
  const GlobalMenuWidget({super.key});

  @override
  State<GlobalMenuWidget> createState() => _GlobalMenuWidgetState();
}

class _GlobalMenuWidgetState extends State<GlobalMenuWidget> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  _GlobalMenuWidgetState();

  @override
  initState() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      _packageInfo = packageInfo;
    });

    super.initState();
  }

  void _openBoard(KingColor kingColor) {
    context.read<GameCubit>().setPlayer(kingColor);
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (context) => const KingdominoWidget()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalMenuAppBar(packageInfo: _packageInfo),
      body: BlocBuilder<RulesCubit, Rules>(
        builder: (context, rules) {
          final hasBrownKing = rules.extension == Extension.ageOfGiants;
          final kings = KingColor.values
              .where((king) => king != KingColor.brown || hasBrownKing)
              .toList();

          return BlocBuilder<GameCubit, Game>(
            builder: (context, game) {
              final maxScore = kings.fold<int>(0, (max, king) {
                final s = game.getPlayerByColor(king).score.total;
                return s > max ? s : max;
              });

              final lostTreasures = rules.extension == Extension.lostTreasures;
              final hasAllGemsByKing = {
                for (final king in kings)
                  king: getKingdomCubit(context, king).state.hasAllGemTypes,
              };
              final anyHasAllGems = hasAllGemsByKing.values.any((v) => v);

              return OrientationBuilder(
                builder: (context, orientation) {
                  final crossAxisCount = orientation == Orientation.portrait
                      ? 2
                      : 3;

                  return GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16.0,
                      crossAxisSpacing: 16.0,
                    ),
                    itemCount: kings.length,
                    itemBuilder: (context, index) {
                      final kingColor = kings[index];
                      final player = game.getPlayerByColor(kingColor);
                      final score = player.score.total;
                      final warnings = player.warnings;
                      final isWinner = lostTreasures && anyHasAllGems
                          ? hasAllGemsByKing[kingColor]!
                          : (score == maxScore && score > 0);

                      return BlocBuilder<KingdomCubit, Kingdom>(
                        bloc: getKingdomCubit(context, kingColor),
                        builder: (context, kingdom) {
                          return InkWell(
                            onTap: () => _openBoard(kingColor),
                            borderRadius: BorderRadius.circular(12.0),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: kingColor.color.withValues(
                                      alpha: 0.15,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: kingColor.color,
                                      width: 2.0,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: KingdomPreviewWidget(
                                          kingdom: kingdom,
                                          kingColor: kingColor,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          ColorFiltered(
                                            colorFilter: ColorFilter.mode(
                                              kingColor.color,
                                              BlendMode.srcATop,
                                            ),
                                            child: Image.asset(
                                              'assets/king_pawn.png',
                                              height: 28,
                                              width: 28,
                                            ),
                                          ),
                                          if (isWinner)
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                left: 4.0,
                                              ),
                                              child: Icon(
                                                Icons.emoji_events,
                                                color: Colors.amber,
                                                size: 20,
                                              ),
                                            ),
                                          const SizedBox(width: 8.0),
                                          Text(
                                            score.toString(),
                                            style: const TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8.0),
                                    ],
                                  ),
                                ),
                                if (warnings.isNotEmpty)
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: Badge(
                                      label: Text(warnings.length.toString()),
                                      child: const Icon(
                                        Icons.warning,
                                        color: Colors.red,
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
            },
          );
        },
      ),
    );
  }
}