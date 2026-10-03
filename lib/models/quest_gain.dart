import 'domain.dart';
import 'kingdom.dart';
import 'land.dart';
import 'quests/quest.dart';

class QuestGain {
  final int row;
  final int col;
  final int points;

  const QuestGain(this.row, this.col, this.points);
}

const Map<QuestType, LandType> _fourCornersTypes = {
  QuestType.fourCornersWheat: LandType.wheat,
  QuestType.fourCornersLake: LandType.lake,
  QuestType.fourCornersForest: LandType.forest,
  QuestType.fourCornersGrassLand: LandType.grassland,
  QuestType.fourCornersSwamp: LandType.swamp,
  QuestType.fourCornersMine: LandType.mine,
};

const Map<QuestType, LandType> _localBusinessTypes = {
  QuestType.localBusinessWheat: LandType.wheat,
  QuestType.localBusinessLake: LandType.lake,
  QuestType.localBusinessForest: LandType.forest,
  QuestType.localBusinessGrassLand: LandType.grassland,
  QuestType.localBusinessSwamp: LandType.swamp,
  QuestType.localBusinessMine: LandType.mine,
};

extension KingdomQuestGains on Kingdom {
  List<QuestGain> computeQuestGains(Map<QuestType, int> questScores) {
    final n = kingdomSize.size;
    final cells = <int, int>{};

    final castles = <(int, int)>[];
    for (var r = 0; r < n; r++) {
      for (var c = 0; c < n; c++) {
        if (getLand(r, c)?.landType == LandType.castle) {
          castles.add((r, c));
        }
      }
    }

    void award(List<(int, int)> places, int total) {
      final targets = places.isEmpty ? castles : places;
      if (targets.isEmpty) return;
      final share = total ~/ targets.length;
      var rest = total - share * targets.length;
      for (final place in targets) {
        final key = place.$1 * n + place.$2;
        cells[key] = (cells[key] ?? 0) + share + rest;
        rest = 0;
      }
    }

    for (final entry in questScores.entries) {
      final type = entry.key;
      final total = entry.value;
      if (total <= 0) continue;

      final places = <(int, int)>[];

      if (_fourCornersTypes.containsKey(type)) {
        final landType = _fourCornersTypes[type];
        for (final corner in [(0, 0), (0, n - 1), (n - 1, 0), (n - 1, n - 1)]) {
          if (getLand(corner.$1, corner.$2)?.landType == landType) {
            places.add(corner);
          }
        }
      } else if (_localBusinessTypes.containsKey(type)) {
        final landType = _localBusinessTypes[type];
        if (castles.isNotEmpty) {
          final castle = castles.first;
          for (var dr = -1; dr <= 1; dr++) {
            for (var dc = -1; dc <= 1; dc++) {
              if (dr == 0 && dc == 0) continue;
              final r = castle.$1 + dr;
              final c = castle.$2 + dc;
              if (isInBound(r, c) && getLand(r, c)?.landType == landType) {
                places.add((r, c));
              }
            }
          }
        }
      } else if (type == QuestType.bleakKing) {
        for (final domain in computeDomains()) {
          if (domain.landCount < 5) continue;
          final hasCrown = domain.cells.any((key) {
            final r = key ~/ n;
            final c = key % n;
            return getLand(r, c)!.crowns > 0 || gemCrownBonus(r, c) > 0;
          });
          if (!hasCrown) {
            places.add((domain.anchorRow, domain.anchorCol));
          }
        }
      } else if (type == QuestType.folieDesGrandeurs) {
        for (final alignment in FolieDesGrandeurs().getAlignments(this)) {
          places.add((alignment.y1, alignment.x1));
        }
      }

      award(places, total);
    }

    return [
      for (final entry in cells.entries)
        QuestGain(entry.key ~/ n, entry.key % n, entry.value),
    ];
  }
}