import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/cubits/domains_mode_cubit.dart';
import 'package:kingdomino_score_count/cubits/game_cubit.dart';
import 'package:kingdomino_score_count/cubits/kingdom_cubit.dart';
import 'package:kingdomino_score_count/cubits/rules_cubit.dart';
import 'package:kingdomino_score_count/cubits/theme_cubit.dart';
import 'package:kingdomino_score_count/cubits/user_selection_cubit.dart';
import 'package:kingdomino_score_count/models/domain.dart';
import 'package:kingdomino_score_count/models/extensions/age_of_giants.dart';
import 'package:kingdomino_score_count/models/extensions/extension.dart';
import 'package:kingdomino_score_count/models/extensions/lacour/lacour.dart';
import 'package:kingdomino_score_count/models/extensions/lost_treasures/lost_treasures.dart';
import 'package:kingdomino_score_count/models/game_set.dart';
import 'package:kingdomino_score_count/models/kingdom.dart';
import 'package:kingdomino_score_count/models/land.dart';
import 'package:kingdomino_score_count/models/quest_gain.dart';
import 'package:kingdomino_score_count/models/quests/quest.dart';
import 'package:kingdomino_score_count/models/user_selection.dart';

import 'alignment_strikes_painter.dart';
import 'domain_borders_painter.dart';
import 'gem_dialog.dart';
import 'gem_widget.dart';
import 'kingdomino_widget.dart';
import 'tile/castle_tile.dart';
import 'tile/land_tile.dart';

class KingdomBoard extends StatelessWidget {
  final Kingdom kingdom;
  final bool editable;
  final Extension extension;
  final KingColor? kingColor;

  const KingdomBoard({
    required this.kingdom,
    required this.editable,
    required this.extension,
    this.kingColor,
    super.key,
  });

  Widget _buildCastle(BuildContext context) {
    return CastleTile(kingColor?.color ?? context.read<ThemeCubit>().state);
  }

  Widget _buildLand(BuildContext context, int y, int x) {
    Land? land = kingdom.getLand(x, y);

    if (land == null) {
      return Text('ERROR $x $y');
    }

    Widget? child;
    if (land.landType == LandType.castle) {
      child = _buildCastle(context);
    } else if (land.courtier != null) {
      child = LandTile(
        landType: land.landType,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image(
            image: AssetImage(courtierPicture[land.courtier.runtimeType]!),
          ),
        ),
      );
    } else {
      if (land.crowns > 0) {
        String text = (crown * land.crowns);
        text += giant * land.giants;
        child = LandTile(
          landType: land.landType,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  text,
                  style: TextStyle(fontSize: constraints.maxWidth / 5),
                ),
              );
            },
          ),
        );
      } else if (land.hasResource) {
        child = LandTile(
          landType: land.landType,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Align(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    getResourceForLandType(land.landType),
                    style: TextStyle(fontSize: constraints.maxWidth / 2),
                  ),
                ),
              );
            },
          ),
        );
      } else {
        child = LandTile(landType: land.landType);
      }
    }

    return child;
  }

  Widget _buildLands(BuildContext context, int index) {
    int gridStateLength = kingdom.getLands().length;

    int x, y = 0;
    x = (index / gridStateLength).floor();
    y = (index % gridStateLength);

    Widget tile = GridTile(child: Container(child: _buildLand(context, y, x)));

    if (!editable) {
      return tile;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          var selectionMode = context
              .read<UserSelectionCubit>()
              .state
              .getSelectionMode();
          var selectedLandType = context
              .read<UserSelectionCubit>()
              .state
              .getSelectedLandType();
          if (selectionMode != SelectionMode.land ||
              selectedLandType != kingdom.getLand(x, y)!.landType) {
            getKingdomCubit(
              context,
              context.read<GameCubit>().state.kingColor!,
            ).setLand(
              x,
              y,
              selectedLandType,
              context.read<UserSelectionCubit>().state.getSelectionMode(),
              context.read<UserSelectionCubit>().state.selectedCourtier,
              context.read<RulesCubit>().state.extension,
            );
            context.read<GameCubit>().setWarnings(
              getKingdomCubit(
                context,
                context.read<GameCubit>().state.kingColor!,
              ).state,
              context.read<RulesCubit>().state,
            );
          }
        },
        child: tile,
      ),
    );
  }

  Widget _buildAlignmentStrikes(double cell) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: AlignmentStrikesPainter(
            alignments: FolieDesGrandeurs().getAlignments(kingdom),
            cell: cell,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildQuestGainOverlays(BuildContext context, double cell) {
    final quests = context.read<RulesCubit>().state.selectedQuests;
    return [
      for (final gain in kingdom.computeQuestGains(quests))
        Positioned(
          left: gain.col * cell,
          top: gain.row * cell,
          width: cell,
          height: cell,
          child: IgnorePointer(
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: const EdgeInsets.all(2),
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '+${gain.points}',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: cell / 5,
                  ),
                ),
              ),
            ),
          ),
        ),
    ];
  }

  List<Widget> _buildDomainOverlays(int n, double cell) {
    final domains = kingdom.computeDomains();
    return [
      Positioned.fill(
        child: IgnorePointer(
          child: CustomPaint(
            painter: DomainBordersPainter(domains: domains, n: n, cell: cell),
          ),
        ),
      ),
      for (final domain in domains) _buildDomainBadge(domain, cell),
    ];
  }

  Widget _buildDomainBadge(Domain domain, double cell) {
    return Positioned(
      left: domain.anchorCol * cell,
      top: domain.anchorRow * cell,
      width: cell,
      height: cell,
      child: IgnorePointer(
        child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: const EdgeInsets.all(2),
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${domain.score}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: cell / 4,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildGemOverlays(BuildContext context, int n, double cell) {
    final widgets = <Widget>[];
    for (var kx = 1; kx < n; kx++) {
      for (var ky = 1; ky < n; ky++) {
        PlacedGem? placed;
        for (final gem in kingdom.gems) {
          if (gem.x == kx && gem.y == ky) {
            placed = gem;
            break;
          }
        }

        if (placed != null) {
          widgets.add(_buildPlacedGem(context, kx, ky, placed, cell));
        } else if (kingdom.hasFourDifferentTiles(kx, ky)) {
          widgets.add(_buildDot(context, kx, ky, cell));
        }
      }
    }
    return widgets;
  }

  Widget _buildDot(BuildContext context, int kx, int ky, double cell) {
    final center = Offset(ky * cell, kx * cell);
    final dotSize = 16.0;
    return Positioned(
      left: center.dx - dotSize / 2,
      top: center.dy - dotSize / 2,
      width: dotSize,
      height: dotSize,
      child: GestureDetector(
        onTap: editable
            ? () => showDialog<void>(
                context: context,
                builder: (context) => GemDialogWidget(x: kx, y: ky),
              )
            : null,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1),
          ),
        ),
      ),
    );
  }

  Widget _buildPlacedGem(
    BuildContext context,
    int kx,
    int ky,
    PlacedGem placed,
    double cell,
  ) {
    final center = Offset(ky * cell, kx * cell);
    final gemSize = cell * 0.6;
    return Positioned(
      left: center.dx - gemSize / 2,
      top: center.dy - gemSize / 2,
      width: gemSize,
      height: gemSize,
      child: GestureDetector(
        onTap: editable
            ? () => showDialog<void>(
                context: context,
                builder: (context) => GemDialogWidget(x: kx, y: ky),
              )
            : null,
        child: Opacity(
          opacity: 0.8,
          child: GemWidget(
            gem: placed.gem,
            orientation: placed.orientation,
            size: gemSize,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int gridStateLength = kingdom.getLands().length;
    final showStrikes = context
        .watch<RulesCubit>()
        .state
        .selectedQuests
        .contains(QuestType.folieDesGrandeurs);
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cell = constraints.maxWidth / gridStateLength;
            return BlocBuilder<DomainsModeCubit, bool>(
              bloc: domainsModeCubit,
              builder: (context, domainsMode) {
                return Stack(
                  children: [
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: gridStateLength,
                      ),
                      itemBuilder: _buildLands,
                      itemCount: gridStateLength * gridStateLength,
                    ),
                    if (domainsMode)
                      ..._buildDomainOverlays(gridStateLength, cell),
                    if (domainsMode && showStrikes)
                      _buildAlignmentStrikes(cell),
                    if (domainsMode)
                      ..._buildQuestGainOverlays(context, cell),
                    if (extension == Extension.lostTreasures)
                      ..._buildGemOverlays(context, gridStateLength, cell),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
