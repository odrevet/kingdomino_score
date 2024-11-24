import 'package:replay_bloc/replay_bloc.dart';

import '../models/kingdom.dart';
import '../models/kingdom_size.dart';

class KingdomCubit extends ReplayCubit<Kingdom> {
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
