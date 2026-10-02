import 'package:kingdomino_score_count/models/extensions/lost_treasures/lost_treasures.dart';
import 'package:kingdomino_score_count/models/kingdom.dart';
import 'package:kingdomino_score_count/models/kingdom_size.dart';
import 'package:kingdomino_score_count/models/land.dart';
import "package:test/test.dart";

void main() {
  test("gem crown quarters are added to the score", () {
    var kingdom = Kingdom(kingdomSize: KingdomSize.small);
    // 2x2 block of 4 different tiles at rows/cols 0..1
    kingdom.getLand(0, 0)!.landType = LandType.wheat;
    kingdom.getLand(1, 0)!.landType = LandType.forest;
    kingdom.getLand(0, 1)!.landType = LandType.lake;
    kingdom.getLand(1, 1)!.landType = LandType.mine;

    expect(kingdom.hasFourDifferentTiles(1, 1), isTrue);

    // crown3 in topLeft points at tile (0,0)
    kingdom.placeGem(
      1,
      1,
      const Gem(
        color: GemColor.blue,
        topLeft: GemQuarter.crown3,
        topRight: GemQuarter.blank,
        bottomLeft: GemQuarter.blank,
        bottomRight: GemQuarter.blank,
      ),
    );

    var score = kingdom.calculateScoreFromProperties(kingdom.getProperties());
    expect(score, 3);
  });

  test("skull quarter cancels the pointed tile crowns", () {
    var kingdom = Kingdom(kingdomSize: KingdomSize.small);
    // 2x2 block of 4 different tiles, each with 1 crown
    kingdom.getLand(0, 0)!.landType = LandType.wheat;
    kingdom.getLand(0, 0)!.crowns = 1;
    kingdom.getLand(1, 0)!.landType = LandType.forest;
    kingdom.getLand(1, 0)!.crowns = 1;
    kingdom.getLand(0, 1)!.landType = LandType.lake;
    kingdom.getLand(0, 1)!.crowns = 1;
    kingdom.getLand(1, 1)!.landType = LandType.mine;
    kingdom.getLand(1, 1)!.crowns = 1;

    // Without gem: 4 properties of 1 tile x 1 crown = 4
    var base = kingdom.calculateScoreFromProperties(kingdom.getProperties());
    expect(base, 4);

    // skull in topLeft cancels tile (0,0) crowns; crown3 in bottomRight
    // adds 3 to tile (1,1)
    kingdom.placeGem(
      1,
      1,
      const Gem(
        color: GemColor.blue,
        topLeft: GemQuarter.skull,
        topRight: GemQuarter.blank,
        bottomLeft: GemQuarter.blank,
        bottomRight: GemQuarter.crown3,
      ),
    );

    // tile(0,0): 0, tile(1,0): 1, tile(0,1): 1, tile(1,1): 1+3=4 => total 6
    var score = kingdom.calculateScoreFromProperties(kingdom.getProperties());
    expect(score, 6);
  });

  test("rotation changes which tile is affected", () {
    var kingdom = Kingdom(kingdomSize: KingdomSize.small);
    kingdom.getLand(0, 0)!.landType = LandType.wheat;
    kingdom.getLand(1, 0)!.landType = LandType.forest;
    kingdom.getLand(0, 1)!.landType = LandType.lake;
    kingdom.getLand(1, 1)!.landType = LandType.mine;

    // crown3 in topLeft. orientation 0 -> tile (0,0). orientation 1 (90° cw)
    // -> topLeft moves to topRight -> tile (1,0).
    kingdom.placeGem(
      1,
      1,
      const Gem(
        color: GemColor.blue,
        topLeft: GemQuarter.crown3,
        topRight: GemQuarter.blank,
        bottomLeft: GemQuarter.blank,
        bottomRight: GemQuarter.blank,
      ),
      1,
    );

    var score = kingdom.calculateScoreFromProperties(kingdom.getProperties());
    expect(score, 3);
    expect(kingdom.gemCrownBonus(1, 0), 3);
    expect(kingdom.gemCrownBonus(0, 0), 0);
  });

  test("hasAllGemTypes is false without all 5 colors", () {
    var kingdom = Kingdom(kingdomSize: KingdomSize.small);
    kingdom.placeGem(1, 1, const Gem(color: GemColor.blue, topLeft: GemQuarter.blank, topRight: GemQuarter.blank, bottomLeft: GemQuarter.blank, bottomRight: GemQuarter.blank));
    kingdom.placeGem(2, 1, const Gem(color: GemColor.red, topLeft: GemQuarter.blank, topRight: GemQuarter.blank, bottomLeft: GemQuarter.blank, bottomRight: GemQuarter.blank));
    kingdom.placeGem(1, 2, const Gem(color: GemColor.green, topLeft: GemQuarter.blank, topRight: GemQuarter.blank, bottomLeft: GemQuarter.blank, bottomRight: GemQuarter.blank));
    kingdom.placeGem(2, 2, const Gem(color: GemColor.yellow, topLeft: GemQuarter.blank, topRight: GemQuarter.blank, bottomLeft: GemQuarter.blank, bottomRight: GemQuarter.blank));
    expect(kingdom.hasAllGemTypes, isFalse);
  });

  test("hasAllGemTypes is true with all 5 colors", () {
    var kingdom = Kingdom(kingdomSize: KingdomSize.small);
    kingdom.placeGem(1, 1, const Gem(color: GemColor.blue, topLeft: GemQuarter.blank, topRight: GemQuarter.blank, bottomLeft: GemQuarter.blank, bottomRight: GemQuarter.blank));
    kingdom.placeGem(2, 1, const Gem(color: GemColor.red, topLeft: GemQuarter.blank, topRight: GemQuarter.blank, bottomLeft: GemQuarter.blank, bottomRight: GemQuarter.blank));
    kingdom.placeGem(1, 2, const Gem(color: GemColor.green, topLeft: GemQuarter.blank, topRight: GemQuarter.blank, bottomLeft: GemQuarter.blank, bottomRight: GemQuarter.blank));
    kingdom.placeGem(2, 2, const Gem(color: GemColor.yellow, topLeft: GemQuarter.blank, topRight: GemQuarter.blank, bottomLeft: GemQuarter.blank, bottomRight: GemQuarter.blank));
    kingdom.placeGem(3, 1, const Gem(color: GemColor.pink, topLeft: GemQuarter.blank, topRight: GemQuarter.blank, bottomLeft: GemQuarter.blank, bottomRight: GemQuarter.blank));
    expect(kingdom.hasAllGemTypes, isTrue);
  });

  test("joker substitutes for one missing color", () {
    var kingdom = Kingdom(kingdomSize: KingdomSize.small);
    kingdom.placeGem(1, 1, const Gem(color: GemColor.blue, topLeft: GemQuarter.blank, topRight: GemQuarter.blank, bottomLeft: GemQuarter.blank, bottomRight: GemQuarter.blank));
    kingdom.placeGem(2, 1, const Gem(color: GemColor.red, topLeft: GemQuarter.blank, topRight: GemQuarter.blank, bottomLeft: GemQuarter.blank, bottomRight: GemQuarter.blank));
    kingdom.placeGem(1, 2, const Gem(color: GemColor.green, topLeft: GemQuarter.blank, topRight: GemQuarter.blank, bottomLeft: GemQuarter.blank, bottomRight: GemQuarter.blank));
    kingdom.placeGem(2, 2, const Gem(color: GemColor.yellow, topLeft: GemQuarter.blank, topRight: GemQuarter.blank, bottomLeft: GemQuarter.blank, bottomRight: GemQuarter.blank));
    kingdom.placeGem(3, 2, const Gem(color: GemColor.joker, topLeft: GemQuarter.blank, topRight: GemQuarter.blank, bottomLeft: GemQuarter.blank, bottomRight: GemQuarter.blank));
    expect(kingdom.hasAllGemTypes, isTrue);
  });

  test("joker alone does not count as all 5 colors", () {
    var kingdom = Kingdom(kingdomSize: KingdomSize.small);
    kingdom.placeGem(3, 2, const Gem(color: GemColor.joker, topLeft: GemQuarter.blank, topRight: GemQuarter.blank, bottomLeft: GemQuarter.blank, bottomRight: GemQuarter.blank));
    expect(kingdom.hasAllGemTypes, isFalse);
  });
}
