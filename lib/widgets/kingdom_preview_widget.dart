import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/cubits/rules_cubit.dart';
import 'package:kingdomino_score_count/models/game_set.dart';
import 'package:kingdomino_score_count/models/kingdom.dart';

import 'kingdom_board.dart';

class KingdomPreviewWidget extends StatelessWidget {
  final Kingdom kingdom;
  final KingColor? kingColor;

  const KingdomPreviewWidget({
    required this.kingdom,
    this.kingColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final extension = context.read<RulesCubit>().state.extension;
    return KingdomBoard(
      kingdom: kingdom,
      editable: false,
      extension: extension,
      kingColor: kingColor,
    );
  }
}