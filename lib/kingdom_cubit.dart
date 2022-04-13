import 'package:kingdomino_score_count/models/land.dart';
import 'package:replay_bloc/replay_bloc.dart';

import 'models/kingdom.dart';

class KingdomCubit extends ReplayCubit<Kingdom> {
  KingdomCubit() : super(Kingdom(size: 5));

  resize(int size) => emit(Kingdom(size: size));

  setLand(int x, int y, LandType landType) => emit(
      state.copyWith()..getLand(x, y)?.landType = landType); //WIP Copy lands
}
