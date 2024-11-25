import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:replay_bloc/replay_bloc.dart';

import '../models/game_set.dart';
import '../models/kingdom.dart';
import '../models/kingdom_size.dart';

abstract class KingdomCubit extends ReplayCubit<Kingdom> {
  KingdomCubit() : super(Kingdom(kingdomSize: KingdomSize.small));

  clear() => emit(Kingdom(kingdomSize: state.kingdomSize));

  resize(KingdomSize kingdomSize) => emit(Kingdom(kingdomSize: kingdomSize));

  setLand(int x, int y, selectedLandType, selectionMode, selectedCourtier,
      extension) {
    var kingdom = state.copyWith();
    kingdom.setLand(
        x, y, selectionMode, selectedLandType, extension, selectedCourtier);
    emit(kingdom);
  }
}

class KingdomCubitPink extends KingdomCubit {}
class KingdomCubitGreen extends KingdomCubit {}
class KingdomCubitYellow extends KingdomCubit {}
class KingdomCubitBlue extends KingdomCubit {}
class KingdomCubitBrown extends KingdomCubit {}

KingdomCubit getKingdomCubit(BuildContext context, KingColor kingColor) {
  switch (kingColor) {
    case KingColor.pink:
      return context.read<KingdomCubitPink>();
    case KingColor.yellow:
      return context.read<KingdomCubitYellow>();
    case KingColor.green:
      return context.read<KingdomCubitGreen>();
    case KingColor.blue:
      return context.read<KingdomCubitBlue>();
    case KingColor.brown:
      return context.read<KingdomCubitBrown>();
  }
}
