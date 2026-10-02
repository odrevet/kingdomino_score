import 'package:kingdomino_score_count/models/warning.dart';

import 'extensions/extension.dart';
import 'extensions/lost_treasures/lost_treasures.dart';
import 'game_set.dart';
import 'kingdom_size.dart';
import 'land.dart';
import 'property.dart';

class Kingdom {
  KingdomSize kingdomSize = KingdomSize.small;
  late List<List<Land>> lands = [];
  List<PlacedGem> gems = [];

  Kingdom({required this.kingdomSize, List<List<Land>>? lands}) {
    if (lands != null) {
      this.lands = lands;
    } else {
      this.lands = [];
      for (var i = 0; i < kingdomSize.size; i++) {
        this.lands.add(List<Land>.generate(kingdomSize.size, (_) => Land()));
      }
    }
  }

  Kingdom copyWith({KingdomSize? kingdomSize, List<List<Land>>? lands}) {
    if (lands == null) {
      var landsCopy = [];
      for (var i = 0; i < this.kingdomSize.size; i++) {
        landsCopy.add(
          List<Land>.generate(
            this.kingdomSize.size,
                (j) => getLand(j, i)!.copyWith(),
          ),
        );
      }
    }
    return Kingdom(
      kingdomSize: kingdomSize ?? this.kingdomSize,
      lands: lands ?? this.lands,
    );
  }

  List<List<Land>> getLands() {
    return lands;
  }

  Land? getLand(int y, int x) {
    if (y < 0 || x < 0 || x > kingdomSize.size || y > kingdomSize.size) {
      return null;
    }

    return lands[x][y];
  }

  void reSize(KingdomSize kingdomSize) {
    this.kingdomSize = kingdomSize;
    lands = [];
    gems = [];
    for (var i = 0; i < kingdomSize.size; i++) {
      lands.add(List<Land>.generate(kingdomSize.size, (_) => Land()));
    }
  }

  void clear() {
    lands.expand((i) => i).toList().forEach((land) {
      land.landType = LandType.empty;
      land.crowns = 0;
      land.giants = 0;
      land.hasResource = false;
      land.courtier = null;
    });
    gems = [];
  }

  bool hasFourDifferentTiles(int x, int y) {
    if (x < 1 || y < 1 || x >= kingdomSize.size || y >= kingdomSize.size) {
      return false;
    }

    final tiles = [
      getLand(x - 1, y - 1),
      getLand(x, y - 1),
      getLand(x - 1, y),
      getLand(x, y),
    ];

    if (tiles.any(
          (land) =>
      land == null ||
          land.landType == LandType.empty ||
          land.landType == LandType.castle,
    )) {
      return false;
    }

    final types = tiles.map((land) => land!.landType).toSet();
    return types.length == 4;
  }

  void placeGem(int x, int y, Gem gem, [int orientation = 0]) {
    gems.removeWhere((placed) => placed.x == x && placed.y == y);
    gems.add(PlacedGem(x: x, y: y, gem: gem, orientation: orientation));
  }

  void removeGem(int x, int y) {
    gems.removeWhere((placed) => placed.x == x && placed.y == y);
  }

  void pruneGems() {
    gems.removeWhere((placed) => !hasFourDifferentTiles(placed.x, placed.y));
  }

  bool get hasAllGemTypes {
    final colors = gems.map((g) => g.gem.color).toSet();
    final realColors = colors.where((c) => c != GemColor.joker).toSet();
    final hasJoker = colors.contains(GemColor.joker);
    final distinctReal = realColors.length;
    return distinctReal == 5 || (distinctReal == 4 && hasJoker);
  }

  GemQuarter? _quarterForTile(PlacedGem placed, int x, int y) {
    final dx = x - placed.x;
    final dy = y - placed.y;

    int position;
    if (dx == -1 && dy == -1) {
      position = 0;
    } else if (dx == -1 && dy == 0) {
      position = 1;
    } else if (dx == 0 && dy == 0) {
      position = 2;
    } else if (dx == 0 && dy == -1) {
      position = 3;
    } else {
      return null;
    }

    return placed.gem.quarterAt((position - placed.orientation) % 4);
  }

  int gemCrownBonus(int x, int y) {
    int bonus = 0;
    for (final placed in gems) {
      final quarter = _quarterForTile(placed, x, y);
      if (quarter != null) {
        bonus += quarter.crowns;
      }
    }
    return bonus;
  }

  bool isSkulled(int x, int y) {
    for (final placed in gems) {
      final quarter = _quarterForTile(placed, x, y);
      if (quarter != null && quarter.isSkull) {
        return true;
      }
    }
    return false;
  }

  int gemCrownBonusTotal() {
    int total = 0;
    for (final placed in gems) {
      for (var p = 0; p < 4; p++) {
        total += placed.gem.quarterAt((p - placed.orientation) % 4).crowns;
      }
    }
    return total;
  }

  List<Property> getProperties() {
    var properties = <Property>[];

    for (var x = 0; x < kingdomSize.size; x++) {
      for (var y = 0; y < kingdomSize.size; y++) {
        var property = _getAdjacentLand(x, y, null);
        if (property != null) {
          properties.add(property);
        }
      }
    }

    lands.expand((i) => i).toList().forEach((land) => land.isMarked = false);

    return properties;
  }

  void _addLandToProperty(int x, int y, Land land, Property property) {
    if (isInBound(x, y)) {
      Land? landToAdd = getLand(x, y);
      if (landToAdd != null &&
          landToAdd.landType == land.landType &&
          landToAdd.isMarked == false) {
        property.landCount++;
        property.crownCount += isSkulled(x, y)
            ? 0
            : landToAdd.getCrowns() + gemCrownBonus(x, y);
        property.giantCount += landToAdd.giants;
        _getAdjacentLand(x, y, property);
      }
    }
  }

  Property? _getAdjacentLand(int x, int y, Property? property) {
    if (!isInBound(x, y)) return null;

    Land? land = getLand(x, y);
    if (land == null ||
        land.landType == LandType.empty ||
        land.landType == LandType.castle ||
        land.isMarked == true) {
      return null;
    }

    if (property == null) {
      property = Property(land.landType);
      property.landCount++;
      property.crownCount += isSkulled(x, y)
          ? 0
          : land.getCrowns() + gemCrownBonus(x, y);
      property.giantCount += land.giants;
    }

    land.isMarked = true;

    _addLandToProperty(x, y - 1, land, property);
    _addLandToProperty(x, y + 1, land, property);
    _addLandToProperty(x - 1, y, land, property);
    _addLandToProperty(x + 1, y, land, property);

    return property;
  }

  int calculateScoreFromProperties(List<Property> properties) {
    int score = 0;
    for (var property in properties) {
      score += property.landCount * property.crownCount;
    }
    return score;
  }

  bool isInBound(int x, int y) {
    return (x >= 0 && x < kingdomSize.size && y >= 0 && y < kingdomSize.size);
  }
}

List<Warning> checkKingdom(Kingdom kingdom, Extension? extension) {
  var warnings = <Warning>[];
  Map<LandType, Map<String, dynamic>> gameSet = getGameSet(extension);

  for (var landType in LandType.values) {
    if (landType != LandType.empty) {
      var count = kingdom
          .getLands()
          .expand((i) => i)
          .toList()
          .where((land) => land.landType == landType)
          .length;
      if (count > gameSet[landType]!['count']) {
        Warning warning = Warning(
          count,
          landType,
          0,
          '>',
          gameSet[landType]!['count'],
        );
        warnings.add(warning);
      }

      for (
      var crownsCounter = 1;
      crownsCounter <= gameSet[landType]!['crowns']['max'];
      crownsCounter++
      ) {
        var count = kingdom
            .getLands()
            .expand((i) => i)
            .toList()
            .where(
              (land) =>
          land.landType == landType && land.crowns == crownsCounter,
        )
            .length;

        if (count > gameSet[landType]!['crowns'][crownsCounter]) {
          Warning warning = Warning(
            count,
            landType,
            crownsCounter,
            '>',
            gameSet[landType]!['crowns'][crownsCounter],
          );

          warnings.add(warning);
        }
      }
    }
  }

  var countEmptyTile = kingdom
      .getLands()
      .expand((i) => i)
      .toList()
      .where((land) => land.landType == LandType.empty)
      .length;

  if (countEmptyTile <= 1) {
    var noCastle = kingdom
        .getLands()
        .expand((i) => i)
        .toList()
        .where((land) => land.landType == LandType.castle)
        .isEmpty;
    if (noCastle) {
      Warning warning = Warning(0, LandType.castle, 0, '≠', 1);
      warnings.add(warning);
    }
  }

  return warnings;
}