import 'package:equatable/equatable.dart';

import '../kingdom.dart';
import 'quest.dart';

class CrownAlignment extends Equatable {
  final int x0, y0;
  final int x1, y1;
  final int x2, y2;

  const CrownAlignment(this.y0, this.x0, this.y1, this.x1, this.y2, this.x2);

  bool cross(CrownAlignment other) =>
      ((x0 == other.x0 && y0 == other.y0) ||
      (x1 == other.x0 && y1 == other.y0) ||
      (x2 == other.x0 && y2 == other.y0) ||
      (x0 == other.x1 && y0 == other.y1) ||
      (x1 == other.x1 && y1 == other.y1) ||
      (x2 == other.x1 && y2 == other.y1) ||
      (x0 == other.x2 && y0 == other.y2) ||
      (x1 == other.x2 && y1 == other.y2) ||
      (x2 == other.x2 && y2 == other.y2));

  @override
  String toString() {
    return '[$x0:$y0 $x1:$y1 $x2:$y2]';
  }

  @override
  List<Object?> get props => [x0, y0, x1, y1, x2, y2];
}

class FolieDesGrandeurs extends Quest {
  static final FolieDesGrandeurs _singleton = FolieDesGrandeurs._internal();

  factory FolieDesGrandeurs() {
    return _singleton;
  }

  FolieDesGrandeurs._internal() : super(reward: 10);

  static const List<List<int>> _orders = [
    [0, 1, 2, 3],
    [0, 1, 3, 2],
    [1, 0, 2, 3],
    [1, 0, 3, 2],
    [2, 3, 0, 1],
    [2, 3, 1, 0],
    [3, 2, 0, 1],
    [3, 2, 1, 0],
  ];

  bool _checkLandBoundAndCrown(int y, int x, Kingdom kingdom) {
    return kingdom.isInBound(x, y) &&
        kingdom.getLand(y, x) != null &&
        kingdom.getLand(y, x)!.getCrowns() > 0;
  }

  bool _hasCrownAlignment(
    int y0,
    int x0,
    int y1,
    int x1,
    int y2,
    int x2,
    Kingdom kingdom,
  ) {
    return _checkLandBoundAndCrown(y0, x0, kingdom) &&
        _checkLandBoundAndCrown(y1, x1, kingdom) &&
        _checkLandBoundAndCrown(y2, x2, kingdom);
  }

  void _addCrownAlignmentVertical(
    List<CrownAlignment> crownAlignment,
    int y,
    int x,
    Kingdom kingdom,
  ) {
    int x1 = x;
    int y1 = y + 1;
    int x2 = x;
    int y2 = y + 2;
    if (_hasCrownAlignment(y, x, y1, x1, y2, x2, kingdom)) {
      crownAlignment.add(CrownAlignment(y, x, y1, x1, y2, x2));
    }
  }

  void _addCrownAlignmentHorizontal(
    List<CrownAlignment> crownAlignment,
    int y,
    int x,
    Kingdom kingdom,
  ) {
    int x1 = x + 1;
    int y1 = y;
    int x2 = x + 2;
    int y2 = y;
    if (_hasCrownAlignment(y, x, y1, x1, y2, x2, kingdom)) {
      crownAlignment.add(CrownAlignment(y, x, y1, x1, y2, x2));
    }
  }

  void _addCrownAlignmentDiagonalRight(
    List<CrownAlignment> crownAlignment,
    int y,
    int x,
    Kingdom kingdom,
  ) {
    int x1 = x + 1;
    int y1 = y + 1;
    int x2 = x + 2;
    int y2 = y + 2;
    if (_hasCrownAlignment(y, x, y1, x1, y2, x2, kingdom)) {
      crownAlignment.add(CrownAlignment(y, x, y1, x1, y2, x2));
    }
  }

  void _addCrownAlignmentDiagonalLeft(
    List<CrownAlignment> crownAlignment,
    int x,
    int y,
    Kingdom kingdom,
  ) {
    int x1 = x - 1;
    int y1 = y + 1;
    int x2 = x - 2;
    int y2 = y + 2;
    if (_hasCrownAlignment(y, x, y1, x1, y2, x2, kingdom)) {
      crownAlignment.add(CrownAlignment(y, x, y1, x1, y2, x2));
    }
  }

  int _countSharedSquare(
    List<List<int>> placedAlignments,
    CrownAlignment crownAlignment,
  ) {
    int sharedSquareCount = 0;
    if (placedAlignments[crownAlignment.x0][crownAlignment.y0] > 1) {
      sharedSquareCount++;
    }
    if (placedAlignments[crownAlignment.x1][crownAlignment.y1] > 1) {
      sharedSquareCount++;
    }
    if (placedAlignments[crownAlignment.x2][crownAlignment.y2] > 1) {
      sharedSquareCount++;
    }

    return sharedSquareCount;
  }

  bool _alignmentAdd(
    CrownAlignment crownAlignment,
    List<CrownAlignment> resultAlignments,
    List<List<int>> placedAlignments,
  ) {
    bool addAlignment = true;
    placedAlignments[crownAlignment.x0][crownAlignment.y0]++;
    placedAlignments[crownAlignment.x1][crownAlignment.y1]++;
    placedAlignments[crownAlignment.x2][crownAlignment.y2]++;

    int sharedSquareCount = _countSharedSquare(
      placedAlignments,
      crownAlignment,
    );

    if (sharedSquareCount == 0) {
      addAlignment = true;
    } else if (sharedSquareCount == 1) {
      int sharedSquareCount = 0;
      for (CrownAlignment resultAlignment in resultAlignments) {
        if (resultAlignment.cross(crownAlignment)) {
          sharedSquareCount += _countSharedSquare(
            placedAlignments,
            resultAlignment,
          );
        }

        if (sharedSquareCount >= 2) {
          addAlignment = false;
          break;
        }
      }
    } else if (sharedSquareCount >= 2) {
      addAlignment = false;
    }

    if (addAlignment) {
      resultAlignments.add(crownAlignment);
    } else {
      placedAlignments[crownAlignment.x0][crownAlignment.y0]--;
      placedAlignments[crownAlignment.x1][crownAlignment.y1]--;
      placedAlignments[crownAlignment.x2][crownAlignment.y2]--;
    }

    return addAlignment;
  }

  List<CrownAlignment> selectValidAlignments(
    List<CrownAlignment> crownAlignments,
    Kingdom kingdom,
  ) {
    List<List<int>> placedAlignments = [];
    for (var i = 0; i < kingdom.kingdomSize.size; i++) {
      placedAlignments.add(
        List<int>.generate(kingdom.kingdomSize.size, (_) => 0),
      );
    }

    List<CrownAlignment> resultAlignments = [];

    for (var crownAlignment in crownAlignments) {
      _alignmentAdd(crownAlignment, resultAlignments, placedAlignments);
    }

    return resultAlignments;
  }

  int countValidAlignments(
    List<CrownAlignment> crownAlignments,
    Kingdom kingdom,
  ) {
    return selectValidAlignments(crownAlignments, kingdom).length;
  }

  List<CrownAlignment> getAlignments(Kingdom kingdom) {
    int size = kingdom.kingdomSize.size;

    List<CrownAlignment> horizontal = [];
    List<CrownAlignment> vertical = [];
    List<CrownAlignment> diagonalRight = [];
    List<CrownAlignment> diagonalLeft = [];

    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        _addCrownAlignmentHorizontal(horizontal, y, x, kingdom);
      }
    }

    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        _addCrownAlignmentVertical(vertical, y, x, kingdom);
      }
    }

    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        _addCrownAlignmentDiagonalRight(diagonalRight, y, x, kingdom);
      }
    }

    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        _addCrownAlignmentDiagonalLeft(diagonalLeft, y, x, kingdom);
      }
    }

    final groups = [horizontal, vertical, diagonalRight, diagonalLeft];

    List<CrownAlignment> best = [];
    for (final order in _orders) {
      final candidates = <CrownAlignment>[
        for (final index in order) ...groups[index],
      ];
      final result = selectValidAlignments(candidates, kingdom);
      if (result.length > best.length) {
        best = result;
      }
    }

    return best;
  }

  @override
  List<(int, int)> getPlaces(Kingdom kingdom) {
    return [
      for (final alignment in getAlignments(kingdom))
        (alignment.y1, alignment.x1),
    ];
  }
}
