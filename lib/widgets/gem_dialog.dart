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
    return SimpleDialog(
      title: const Text('Choose a gem'),
      children: [
        for (var i = 0; i < fakeGems.length; i++)
          _GemOption(
            gem: fakeGems[i],
            orientation: _orientations[i] ?? 0,
            onRotate: () => setState(() {
              _orientations[i] = ((_orientations[i] ?? 0) + 1) % 4;
            }),
            onSelect: () => _place(fakeGems[i], _orientations[i] ?? 0),
          ),
      ],
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
    return SimpleDialogOption(
      onPressed: onSelect,
      child: Row(
        children: [
          GemWidget(gem: gem, orientation: orientation, size: 48),
          const SizedBox(width: 12),
          const Expanded(child: Text('Place')),
          IconButton(
            icon: const Icon(Icons.rotate_right),
            tooltip: 'Rotate',
            onPressed: onRotate,
          ),
        ],
      ),
    );
  }
}
