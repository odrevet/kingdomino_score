import "package:test/test.dart";

import 'package:kingdomino_score_count/models/kingdom.dart';
import 'package:kingdomino_score_count/models/quests/folie_des_grandeurs.dart';

/// Test crown configuration on multiple kingdoms
/// We add crowns on lands of type 'none', which never happen in the actual
/// game but do not matter for tests has folieDesGrandeurs score is only
/// affected by crowns and not land types.

/// Each alignment scores 10 points, so we will expect 10 times the number
/// of expected alignments


_setCrowns(Kingdom kingdom, List<List<int>> crowns){
  for (var x = 0; x < kingdom.size; x++) {
    for (var y = 0; y < kingdom.size; y++) {
      kingdom.getLand(y, x).crowns = crowns[y][x];
    }
  }
}

void main() {

  ///Expect 3 alignments, either horizontal or vertical
  test("square 3x3", () {
    var kingdom = Kingdom(5);

    List<List<int>> crowns = [
      [1, 1, 1, 0, 0],
      [1, 1, 1, 0, 0],
      [1, 1, 1, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0]
    ];

    _setCrowns(kingdom, crowns);

    var folieDesGrandeurs = FolieDesGrandeurs();
    expect(30, folieDesGrandeurs.getPoints(kingdom));
  });

  ///Expect 10 alignments, either horizontal or vertical
  /// this configuration is impossible in the actual game as the castle
  /// cannot have crown, but it should be tested anyway as it may happen in a
  /// 7x7 kingdom
  test("full", () {
    var kingdom = Kingdom(5);

    List<List<int>> crowns = [
      [1, 1, 1, 1, 1],
      [1, 1, 1, 1, 1],
      [1, 1, 1, 1, 1],
      [1, 1, 1, 1, 1],
      [1, 1, 1, 1, 1]
    ];

    _setCrowns(kingdom, crowns);

    var folieDesGrandeurs = FolieDesGrandeurs();
    expect(100, folieDesGrandeurs.getPoints(kingdom));
  });

  /// A 3x3 square with an extra crown at the bottom right
  /// 4 alignments :
  /// 0:0 0:1 0:2
  /// 0;2 1:1 0:2
  /// 0:1 1:2 3:3
  /// 2:1 2:2 2:3
  test("shape #1", () {
    var kingdom = Kingdom(5);

    List<List<int>> crowns = [
      [1, 1, 1, 0, 0],
      [1, 1, 1, 0, 0],
      [1, 1, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 0, 0, 0]
    ];

    _setCrowns(kingdom, crowns);

    var folieDesGrandeurs = FolieDesGrandeurs();
    expect(40, folieDesGrandeurs.getPoints(kingdom));
  });

   ///Expect 3 alignments
  ///the horizontal double alignment should not be used as it will prevent
  ///the diagonal and the vertical alignment to be used
  /// prevent
  test("shape #2", () {
    var kingdom = Kingdom(5);

    List<List<int>> crowns = [
      [0, 0, 0, 0, 1],
      [0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1],
      [0, 0, 1, 0, 0],
      [0, 1, 0, 0, 0]
    ];

    _setCrowns(kingdom, crowns);

    var folieDesGrandeurs = FolieDesGrandeurs();
    expect(30, folieDesGrandeurs.getPoints(kingdom));
  });

}
