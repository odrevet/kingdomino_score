import 'dart:collection';
import 'package:kingdomino_score_count/models/extensions/lost_treasures/lost_treasures.dart';
import 'package:kingdomino_score_count/models/kingdom.dart';
import 'package:kingdomino_score_count/models/kingdom_size.dart';
import 'package:kingdomino_score_count/models/land.dart';
import 'package:kingdomino_score_count/models/score.dart';
import "package:test/test.dart";

void main() {
  test("Score.updateScore includes gem crowns", () {
    var kingdom = Kingdom(kingdomSize: KingdomSize.small);
    kingdom.getLand(0, 0)!.landType = LandType.wheat;
    kingdom.getLand(0, 0)!.crowns = 2;
    kingdom.getLand(1, 0)!.landType = LandType.forest;
    kingdom.getLand(1, 0)!.crowns = 1;
    kingdom.getLand(0, 1)!.landType = LandType.lake;
    kingdom.getLand(0, 1)!.crowns = 1;
    kingdom.getLand(1, 1)!.landType = LandType.mine;
    kingdom.getLand(1, 1)!.crowns = 1;

    const gem = Gem(
      color: GemColor.blue,
      topLeft: GemQuarter.skull,
      topRight: GemQuarter.blank,
      bottomLeft: GemQuarter.blank,
      bottomRight: GemQuarter.crown3,
    );
    kingdom.placeGem(1, 1, gem, 1);

    var score = Score(scoreQuest: {});
    score.updateScore(kingdom, null, HashSet());
    expect(score.total, 7);
  });
}
