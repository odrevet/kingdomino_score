import 'package:kingdomino_score_count/models/warning.dart';

import 'models/extensions/age_of_giants.dart';
import 'models/extensions/extension.dart';
import 'models/extensions/lacour/lacour.dart';
import 'models/game_set.dart';
import 'models/kingdom.dart';
import 'models/land.dart';

Map<LandType, Map<String, dynamic>> getGameSet(extension) {
  if (extension == Extension.ageOfGiants) {
    return gameAogSet;
  } else if (extension == Extension.laCour) {
    return laCourGameSet;
  } else {
    return gameSet;
  }
}

List<Warning> checkKingdom(Kingdom kingdom, Extension? extension) {
  var warnings = <Warning>[];
  Map<LandType, Map<String, dynamic>> gameSet = getGameSet(extension);

  //check if more tile in the kingdom than in the gameSet
  for (var landType in LandType.values) {
    if (landType != LandType.empty) {
      var count = kingdom
          .getLands()
          .expand((i) => i)
          .toList()
          .where((land) => land.landType == landType)
          .length;
      if (count > gameSet[landType]!['count']) {
        Warning warning =
            Warning(count, landType, 0, '>', gameSet[landType]!['count']);
        warnings.add(warning);
      }

      //check if too many tile with given crowns
      for (var crownsCounter = 1;
          crownsCounter <= gameSet[landType]!['crowns']['max'];
          crownsCounter++) {
        var count = kingdom
            .getLands()
            .expand((i) => i)
            .toList()
            .where((land) =>
                land.landType == landType && land.crowns == crownsCounter)
            .length;

        if (count > gameSet[landType]!['crowns'][crownsCounter]) {
          Warning warning = Warning(count, landType, crownsCounter, '>',
              gameSet[landType]!['crowns'][crownsCounter]);

          warnings.add(warning);
        }
      }
    }

    // Check if kingdom has castle (when less than a blank tile in board)
    var countEmptyTile = kingdom
        .getLands()
        .expand((i) => i)
        .toList()
        .where((land) => land.landType == LandType.empty)
        .length;

    var noCastle = kingdom
        .getLands()
        .expand((i) => i)
        .toList()
        .where((land) => land.landType == LandType.castle)
        .isEmpty;
    if (countEmptyTile <= 1 && noCastle) {
      Warning warning = Warning(0, LandType.castle, 0, '<>', 1);
      warnings.add(warning);
    }
  }

  return warnings;
}
