import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/cubits/game_cubit.dart';
import 'package:kingdomino_score_count/cubits/kingdom_cubit.dart';
import 'package:kingdomino_score_count/cubits/rules_cubit.dart';
import 'package:kingdomino_score_count/models/extensions/extension.dart';
import 'package:kingdomino_score_count/models/game_set.dart';
import 'package:kingdomino_score_count/models/kingdom.dart';
import 'package:kingdomino_score_count/models/land.dart';
import 'package:kingdomino_score_count/models/player.dart';

class _PickerData {
  final List<_PlayerData> players;
  final KingColor currentColor;

  _PickerData({required this.players, required this.currentColor});
}

class _PlayerData {
  final Player player;
  final Kingdom kingdom;

  _PlayerData({required this.player, required this.kingdom});
}

void showKingdomPicker(BuildContext context) {
  final game = context.read<GameCubit>().state;
  final hasBrownKing =
      context.read<RulesCubit>().state.extension == Extension.ageOfGiants;
  final players = game.players
      .where((p) => p.kingColor != KingColor.brown || hasBrownKing)
      .map((p) {
    final kingdom = getKingdomCubit(context, p.kingColor).state;
    return _PlayerData(player: p, kingdom: kingdom);
  }).toList();

  final data = _PickerData(
    players: players,
    currentColor: game.kingColor!,
  );

  showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    builder: (ctx) => _KingdomPicker(data: data),
  );
}

class _KingdomPicker extends StatelessWidget {
  final _PickerData data;

  const _KingdomPicker({required this.data});

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = data.players.length <= 3 ? data.players.length : 2;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Kingdomes',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.85,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: data.players.length,
            itemBuilder: (context, index) {
              final pd = data.players[index];
              final isCurrent = pd.player.kingColor == data.currentColor;
              return _KingdomCard(
                player: pd.player,
                kingdom: pd.kingdom,
                isCurrent: isCurrent,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _KingdomCard extends StatelessWidget {
  final Player player;
  final Kingdom kingdom;
  final bool isCurrent;

  const _KingdomCard({
    required this.player,
    required this.kingdom,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final size = kingdom.kingdomSize.size;

    return GestureDetector(
      onTap: () {
        context.read<GameCubit>().setPlayer(player.kingColor);
        Navigator.of(context).pop();
      },
      child: Card(
        elevation: isCurrent ? 4 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: isCurrent
              ? BorderSide(color: player.kingColor.color, width: 2)
              : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      player.kingColor.color,
                      BlendMode.srcATop,
                    ),
                    child: Image.asset(
                      'assets/king_pawn.png',
                      height: 28,
                      width: 28,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    player.score.total.toString(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Expanded(
                child: MiniKingdomGrid(size: size, kingdom: kingdom),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MiniKingdomGrid extends StatelessWidget {
  final int size;
  final Kingdom kingdom;

  const MiniKingdomGrid({
    required this.size,
    required this.kingdom,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: AspectRatio(
        aspectRatio: 1,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: size,
          ),
          itemCount: size * size,
          itemBuilder: (context, index) {
            final x = (index / size).floor();
            final y = (index % size);
            final land = kingdom.getLand(x, y);
            return Container(
              decoration: BoxDecoration(
                color: land != null
                    ? getColorForLandType(land.landType)
                    : Colors.transparent,
                border: Border.all(
                  color: Colors.grey.shade400,
                  width: 0.5,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
