import 'package:kingdomino_score_count/models/land.dart';
import 'package:kingdomino_score_count/widgets/kingdomino_widget.dart';
import 'package:replay_bloc/replay_bloc.dart';

import '../models/kingdom.dart';
import '../models/lacour/lacour.dart';

class KingdomCubit extends ReplayCubit<Kingdom> {
  KingdomCubit() : super(Kingdom(size: 5));

  clear() => emit(Kingdom(size: state.size));

  resize(int size) => emit(Kingdom(size: size));

  setLand(int y, int x, selectedLandType, getSelectionMode, getGameSet,
      getSelectedCourtierType) {
    var kingdom = Kingdom(size: state.size);
    for (var x = 0; x < state.size; x++) {
      for (var y = 0; y < state.size; y++) {
        kingdom.lands[y][x] = state.getLand(x, y)!.copyWith();
      }
    }

    Land? land = kingdom.getLand(y, x);

    switch (getSelectionMode()) {
      case SelectionMode.land:
        land!.landType = selectedLandType;
        land.reset();
        break;
      case SelectionMode.crown:
        if (land!.landType == LandType.castle || land.landType == null) break;
        land.crowns++;
        land.courtierType = null;
        if (land.crowns > getGameSet()[land.landType]['crowns']['max']) {
          land.reset();
        }
        break;
      case SelectionMode.castle:
        //remove other castle, if any
        for (var cx = 0; cx < kingdom.size; cx++) {
          for (var cy = 0; cy < kingdom.size; cy++) {
            if (kingdom.getLand(cx, cy)?.landType == LandType.castle) {
              kingdom.getLand(cx, cy)?.landType = null;
              kingdom.getLand(cx, cy)?.crowns = 0;
            }
          }
        }

        land!.landType = selectedLandType; //should be castle
        land.reset();
        break;
      case SelectionMode.giant:
        land!.giants = (land.giants + 1) % (land.crowns + 1);
        break;
      case SelectionMode.courtier:
        if ([
          LandType.grassland,
          LandType.lake,
          LandType.wheat,
          LandType.forest,
          LandType.mine,
          LandType.swamp
        ].contains(land!.landType)) {
          CourtierType courtierType = getSelectedCourtierType();
          if (land.courtierType == courtierType) {
            land.courtierType = null;
            break;
          }

          //remove same courtier type, if any
          for (var cx = 0; cx < kingdom.size; cx++) {
            for (var cy = 0; cy < kingdom.size; cy++) {
              if (kingdom.getLand(cx, cy)?.courtierType == courtierType) {
                kingdom.getLand(cx, cy)?.courtierType = null;
              }
            }
          }

          land.reset();
          land.courtierType = courtierType;
        }
        break;
      case SelectionMode.resource:
        if ([LandType.grassland, LandType.lake, LandType.wheat, LandType.forest]
            .contains(land!.landType)) {
          land.hasResource = !land.hasResource;
          land.crowns = 0;
        }
        break;
    }

    emit(kingdom);
  }
}
