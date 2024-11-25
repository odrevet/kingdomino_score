import 'package:kingdomino_score_count/models/game_set.dart';
import 'package:kingdomino_score_count/models/land.dart';
import 'package:replay_bloc/replay_bloc.dart';

import '../models/kingdom.dart';
import '../models/kingdom_size.dart';
import '../models/user_selection.dart';

class KingdomCubit extends ReplayCubit<Kingdom> {
  KingdomCubit()
      : super(Kingdom(kingdomSize: KingdomSize.small));

  clear() => emit(Kingdom(kingdomSize: state.kingdomSize));

  resize(KingdomSize kingdomSize) => emit(Kingdom(kingdomSize: kingdomSize));

  setLand(int y, int x, selectedLandType, selectionMode, selectedCourtier,
      extension) {
    bool isValid = true;

    var kingdom = Kingdom(kingdomSize: state.kingdomSize);
    for (var x = 0; x < state.kingdomSize.size; x++) {
      for (var y = 0; y < state.kingdomSize.size; y++) {
        kingdom.lands[y][x] = state.getLand(x, y)!.copyWith();
      }
    }

    Land? land = kingdom.getLand(y, x);

    switch (selectionMode) {
      case SelectionMode.land:
        land!.landType = selectedLandType;
        land.reset();
        break;
      case SelectionMode.crown:
        if (land!.landType == LandType.castle ||
            land.landType == LandType.empty) {
          isValid = false;
        } else {
          land.crowns++;
          land.courtier = null;
          if (land.crowns >
              getGameSet(extension)[land.landType]?['crowns']['max']) {
            land.reset();
          }
        }
        break;
      case SelectionMode.castle:
        //remove other castle, if any
        for (var cx = 0; cx < kingdom.kingdomSize.size; cx++) {
          for (var cy = 0; cy < kingdom.kingdomSize.size; cy++) {
            if (kingdom.getLand(cx, cy)?.landType == LandType.castle) {
              kingdom.getLand(cx, cy)?.landType = LandType.empty;
              kingdom.getLand(cx, cy)?.crowns = 0;
            }
          }
        }

        land!.landType = selectedLandType; //should be castle
        land.reset();
        break;
      case SelectionMode.giant:
        if (land!.crowns > 0) {
          land.giants = (land.giants + 1) % (land.crowns + 1);
        } else {
          isValid = false;
        }
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
          if (land.courtier == selectedCourtier) {
            land.courtier = null;
            break;
          }

          //remove same courtier type, if any
          for (var cx = 0; cx < kingdom.kingdomSize.size; cx++) {
            for (var cy = 0; cy < kingdom.kingdomSize.size; cy++) {
              if (kingdom.getLand(cx, cy)?.courtier == selectedCourtier) {
                kingdom.getLand(cx, cy)?.courtier = null;
              }
            }
          }

          land.reset();
          land.courtier = selectedCourtier;
        } else {
          isValid = false;
        }
        break;
      case SelectionMode.resource:
        if ([LandType.grassland, LandType.lake, LandType.wheat, LandType.forest]
            .contains(land!.landType)) {
          land.hasResource = !land.hasResource;
          land.crowns = 0;
        } else {
          isValid = false;
        }
        break;
    }

    if (isValid) emit(kingdom);
  }
}
