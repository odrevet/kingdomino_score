import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/cubits/game_cubit.dart';
import 'package:kingdomino_score_count/cubits/kingdom_cubit.dart';
import 'package:kingdomino_score_count/models/extensions/lost_treasures/lost_treasures.dart';

import 'gem_widget.dart';

class GemDialogWidget extends StatefulWidget {
  final int x;
  final int y;

  const GemDialogWidget({required this.x, required this.y, super.key});

  @override
  State<GemDialogWidget> createState() => _GemDialogWidgetState();
}

class _GemDialogWidgetState extends State<GemDialogWidget> {
  final Map<int, int> _orientations = {};

  void _place(Gem gem, int orientation) {
    getKingdomCubit(
      context,
      context.read<GameCubit>().state.kingColor!,
    ).placeGem(widget.x, widget.y, gem, orientation);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < gems.length; i++)
                _GemOption(
                  gem: gems[i],
                  orientation: _orientations[i] ?? 0,
                  onRotate: () => setState(() {
                    _orientations[i] = ((_orientations[i] ?? 0) + 1) % 4;
                  }),
                  onSelect: () => _place(gems[i], _orientations[i] ?? 0),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GemOption extends StatelessWidget {
  final Gem gem;
  final int orientation;
  final VoidCallback onRotate;
  final VoidCallback onSelect;

  const _GemOption({
    required this.gem,
    required this.orientation,
    required this.onRotate,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GemWidget(gem: gem, orientation: orientation, size: 48),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.rotate_right),
              tooltip: 'Rotate',
              onPressed: onRotate,
            ),
          ],
        ),
      ),
    );
  }}
