import 'package:flutter/material.dart';

enum GemColor { blue, yellow, green, red, pink }

extension GemColorX on GemColor {
  Color get color {
    switch (this) {
      case GemColor.blue:
        return Colors.blue;
      case GemColor.yellow:
        return Colors.yellow;
      case GemColor.green:
        return Colors.green;
      case GemColor.red:
        return Colors.red;
      case GemColor.pink:
        return Colors.pink;
    }
  }
}

enum GemQuarter { blank, crown1, crown2, crown3, skull }

extension GemQuarterX on GemQuarter {
  int get crowns {
    switch (this) {
      case GemQuarter.crown1:
        return 1;
      case GemQuarter.crown2:
        return 2;
      case GemQuarter.crown3:
        return 3;
      default:
        return 0;
    }
  }

  bool get isSkull => this == GemQuarter.skull;
}

class Gem {
  final GemColor color;
  final GemQuarter topLeft;
  final GemQuarter topRight;
  final GemQuarter bottomLeft;
  final GemQuarter bottomRight;

  const Gem({
    required this.color,
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
  });

  /// Quarter at a clockwise position: 0=topLeft, 1=topRight,
  /// 2=bottomRight, 3=bottomLeft.
  GemQuarter quarterAt(int position) {
    switch (position % 4) {
      case 0:
        return topLeft;
      case 1:
        return topRight;
      case 2:
        return bottomRight;
      case 3:
        return bottomLeft;
    }
    return GemQuarter.blank;
  }
}

class PlacedGem {
  final int x;
  final int y;
  final Gem gem;
  final int orientation;

  const PlacedGem({
    required this.x,
    required this.y,
    required this.gem,
    this.orientation = 0,
  });
}

/// Fake set of gems (the real extension is not released yet).
/// 5 colors, 3 copies each, with varied quarter patterns.
const List<Gem> fakeGems = [
  // blue
  Gem(
    color: GemColor.blue,
    topLeft: GemQuarter.crown3,
    topRight: GemQuarter.blank,
    bottomLeft: GemQuarter.blank,
    bottomRight: GemQuarter.blank,
  ),
  Gem(
    color: GemColor.blue,
    topLeft: GemQuarter.crown2,
    topRight: GemQuarter.blank,
    bottomLeft: GemQuarter.blank,
    bottomRight: GemQuarter.crown1,
  ),
  Gem(
    color: GemColor.blue,
    topLeft: GemQuarter.skull,
    topRight: GemQuarter.blank,
    bottomLeft: GemQuarter.blank,
    bottomRight: GemQuarter.crown3,
  ),
  // yellow
  Gem(
    color: GemColor.yellow,
    topLeft: GemQuarter.crown3,
    topRight: GemQuarter.blank,
    bottomLeft: GemQuarter.blank,
    bottomRight: GemQuarter.blank,
  ),
  Gem(
    color: GemColor.yellow,
    topLeft: GemQuarter.crown1,
    topRight: GemQuarter.crown1,
    bottomLeft: GemQuarter.crown1,
    bottomRight: GemQuarter.blank,
  ),
  Gem(
    color: GemColor.yellow,
    topLeft: GemQuarter.skull,
    topRight: GemQuarter.blank,
    bottomLeft: GemQuarter.blank,
    bottomRight: GemQuarter.crown3,
  ),
  // green
  Gem(
    color: GemColor.green,
    topLeft: GemQuarter.crown2,
    topRight: GemQuarter.blank,
    bottomLeft: GemQuarter.blank,
    bottomRight: GemQuarter.crown1,
  ),
  Gem(
    color: GemColor.green,
    topLeft: GemQuarter.blank,
    topRight: GemQuarter.skull,
    bottomLeft: GemQuarter.crown2,
    bottomRight: GemQuarter.blank,
  ),
  Gem(
    color: GemColor.green,
    topLeft: GemQuarter.crown3,
    topRight: GemQuarter.blank,
    bottomLeft: GemQuarter.blank,
    bottomRight: GemQuarter.blank,
  ),
  // red
  Gem(
    color: GemColor.red,
    topLeft: GemQuarter.skull,
    topRight: GemQuarter.blank,
    bottomLeft: GemQuarter.blank,
    bottomRight: GemQuarter.crown3,
  ),
  Gem(
    color: GemColor.red,
    topLeft: GemQuarter.crown1,
    topRight: GemQuarter.crown1,
    bottomLeft: GemQuarter.crown1,
    bottomRight: GemQuarter.blank,
  ),
  Gem(
    color: GemColor.red,
    topLeft: GemQuarter.crown2,
    topRight: GemQuarter.blank,
    bottomLeft: GemQuarter.blank,
    bottomRight: GemQuarter.crown1,
  ),
  // pink
  Gem(
    color: GemColor.pink,
    topLeft: GemQuarter.blank,
    topRight: GemQuarter.skull,
    bottomLeft: GemQuarter.crown2,
    bottomRight: GemQuarter.blank,
  ),
  Gem(
    color: GemColor.pink,
    topLeft: GemQuarter.crown3,
    topRight: GemQuarter.blank,
    bottomLeft: GemQuarter.blank,
    bottomRight: GemQuarter.blank,
  ),
  Gem(
    color: GemColor.pink,
    topLeft: GemQuarter.skull,
    topRight: GemQuarter.blank,
    bottomLeft: GemQuarter.blank,
    bottomRight: GemQuarter.crown3,
  ),
];
