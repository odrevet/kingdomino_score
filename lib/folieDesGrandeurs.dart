import 'dart:math';

import 'kingdom.dart';
import 'quest.dart';

///`2 different alignments cannot share more than one square`
///see https://boardgamegeek.com/thread/2040636/tic-tac-toe-bonus-challenge-tile-clarification
class CrownAlignment {
  int x0, y0;
  int x1, y1;
  int x2, y2;

  CrownAlignment(this.y0, this.x0, this.y1, this.x1, this.y2, this.x2);
}

class FolieDesGrandeurs extends Quest {
  int extraPoints = 10;

  FolieDesGrandeurs();

  ///check if land at coord is in bound and has at least a crown
  bool _checkLandBoundAndCrown(int y, int x, Kingdom kingdom) {
    return kingdom.isInBound(x, y) && kingdom.getLand(y, x).getCrowns() > 0;
  }

  // for every land listed has at least a crown
  bool _hasCrownAlignment(
      int y0, int x0, int y1, int x1, int y2, int x2, Kingdom kingdom) {
    return _checkLandBoundAndCrown(y0, x0, kingdom) &&
        _checkLandBoundAndCrown(y1, x1, kingdom) &&
        _checkLandBoundAndCrown(y2, x2, kingdom);
  }

  void _addCrownAlignmentVertical(
      List<CrownAlignment> crownAlignment, int y, int x, Kingdom kingdom) {
    int x1 = x;
    int y1 = y + 1;
    int x2 = x;
    int y2 = y + 2;
    if (_hasCrownAlignment(y, x, y1, x1, y2, x2, kingdom))
      crownAlignment.add(CrownAlignment(y, x, y1, x1, y2, x2));
  }

  void _addCrownAlignmentHorizontal(
      List<CrownAlignment> crownAlignment, int y, int x, Kingdom kingdom) {
    int x1 = x + 1;
    int y1 = y;
    int x2 = x + 2;
    int y2 = y;
    if (_hasCrownAlignment(y, x, y1, x1, y2, x2, kingdom))
      crownAlignment.add(CrownAlignment(y, x, y1, x1, y2, x2));
  }

  void _addCrownAlignmentDiagonalRight(
      List<CrownAlignment> crownAlignment, int y, int x, Kingdom kingdom) {
    int x1 = x + 1;
    int y1 = y + 1;
    int x2 = x + 2;
    int y2 = y + 2;
    if (_hasCrownAlignment(y, x, y1, x1, y2, x2, kingdom))
      crownAlignment.add(CrownAlignment(y, x, y1, x1, y2, x2));
  }

  void _addCrownAlignmentDiagonalLeft(
      List<CrownAlignment> crownAlignment, int x, int y, Kingdom kingdom) {
    int x1 = x - 1;
    int y1 = y + 1;
    int x2 = x - 2;
    int y2 = y + 2;
    if (_hasCrownAlignment(y, x, y1, x1, y2, x2, kingdom))
      crownAlignment.add(CrownAlignment(y, x, y1, x1, y2, x2));
  }

  ///return how many square is shared by crownAlignment on the placedAlignments
  int _countSharedSquare(
      List<List<int>> placedAlignments, CrownAlignment crownAlignment) {
    int sharedSquareCount = 0;
    if (placedAlignments[crownAlignment.x0][crownAlignment.y0] > 1)
      sharedSquareCount++;
    if (placedAlignments[crownAlignment.x1][crownAlignment.y1] > 1)
      sharedSquareCount++;
    if (placedAlignments[crownAlignment.x2][crownAlignment.y2] > 1)
      sharedSquareCount++;

    return sharedSquareCount;
  }

  bool _alignmentCrosses(crownAlignmentA, crownAlignmentB) {
    return ((crownAlignmentA.x0 == crownAlignmentB.x0 &&
        crownAlignmentA.y0 == crownAlignmentB.y0) ||
        (crownAlignmentA.x1 == crownAlignmentB.x0 &&
            crownAlignmentA.y1 == crownAlignmentB.y0) ||
        (crownAlignmentA.x2 == crownAlignmentB.x0 &&
            crownAlignmentA.y2 == crownAlignmentB.y0) ||
        (crownAlignmentA.x0 == crownAlignmentB.x1 &&
            crownAlignmentA.y0 == crownAlignmentB.y1) ||
        (crownAlignmentA.x1 == crownAlignmentB.x1 &&
            crownAlignmentA.y1 == crownAlignmentB.y1) ||
        (crownAlignmentA.x2 == crownAlignmentB.x1 &&
            crownAlignmentA.y2 == crownAlignmentB.y1) ||
        (crownAlignmentA.x0 == crownAlignmentB.x2 &&
            crownAlignmentA.y0 == crownAlignmentB.y2) ||
        (crownAlignmentA.x1 == crownAlignmentB.x2 &&
            crownAlignmentA.y1 == crownAlignmentB.y2) ||
        (crownAlignmentA.x2 == crownAlignmentB.x2 &&
            crownAlignmentA.y2 == crownAlignmentB.y2));
  }

  int countValidAlignments(
      List<CrownAlignment> crownAlignments, Kingdom kingdom) {
    //count for every land how many square crosses
    List<List<int>> placedAlignments = [];
    for (var i = 0; i < kingdom.size; i++) {
      placedAlignments.add(List<int>.generate(kingdom.size, (_) => 0));
    }

    //do not keep alignments that have more than one shared square with another
    //alignment, and do not keep an alignment if an other alignment will share
    //more than one square when the said alignment would be place
    List<CrownAlignment> resultAlignments = List();

    crownAlignments.forEach((crownAlignment) {
      bool addAlignment = true;
      placedAlignments[crownAlignment.x0][crownAlignment.y0]++;
      placedAlignments[crownAlignment.x1][crownAlignment.y1]++;
      placedAlignments[crownAlignment.x2][crownAlignment.y2]++;

      //check if more than one shared square for the alignment being checked
      int sharedSquareCount =
      _countSharedSquare(placedAlignments, crownAlignment);

      /*print(
          '-----\n${crownAlignment.x0}:${crownAlignment.y0} ${crownAlignment.x1}:${crownAlignment.y1} ${crownAlignment.x2}:${crownAlignment.y2}');
      print('shared square count $sharedSquareCount');*/

      if (sharedSquareCount == 0) {
        addAlignment = true;
      } else if (sharedSquareCount == 1) {
        int sharedSquareCount = 0;
        for (CrownAlignment resultAlignment in resultAlignments) {
          if (_alignmentCrosses(resultAlignment, crownAlignment)) {
            sharedSquareCount +=
                _countSharedSquare(placedAlignments, resultAlignment);
            //print('  * shared square count $sharedSquareCount');
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
        //print('ADD');
        resultAlignments.add(crownAlignment);
      } else {
        placedAlignments[crownAlignment.x0][crownAlignment.y0]--;
        placedAlignments[crownAlignment.x1][crownAlignment.y1]--;
        placedAlignments[crownAlignment.x2][crownAlignment.y2]--;
      }
    });

    return resultAlignments.length;
  }

  int getPoints(Kingdom kingdom) {
    int size = kingdom.size;

    //get every alignments, regardless of shared squares
    List<CrownAlignment> alignmentVertical = List();
    List<CrownAlignment> alignmentHorizontal = List();
    List<CrownAlignment> alignmentDiagonalRight = List();
    List<CrownAlignment> alignmentDiagonalLeft = List();

    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        _addCrownAlignmentVertical(alignmentVertical, y, x, kingdom);
      }
    }

    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        _addCrownAlignmentHorizontal(alignmentHorizontal, y, x, kingdom);
      }
    }

    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        _addCrownAlignmentDiagonalRight(alignmentDiagonalRight, y, x, kingdom);
      }
    }

    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        _addCrownAlignmentDiagonalLeft(alignmentDiagonalLeft, y, x, kingdom);
      }
    }

    //sometimes check in for diagonals first gets more points and sometime
    //less. Try different strategies and keep the one that scores the most
    List<int> validAlignments = [];

    validAlignments.add(countValidAlignments([
      ...alignmentHorizontal,
      ...alignmentVertical,
      ...alignmentDiagonalRight,
      ...alignmentDiagonalLeft,
    ], kingdom));

    validAlignments.add(countValidAlignments([
      ...alignmentHorizontal,
      ...alignmentVertical,
      ...alignmentDiagonalLeft,
      ...alignmentDiagonalRight,
    ], kingdom));

    validAlignments.add(countValidAlignments([
      ...alignmentVertical,
      ...alignmentHorizontal,
      ...alignmentDiagonalRight,
      ...alignmentDiagonalLeft,
    ], kingdom));

    validAlignments.add(countValidAlignments([
      ...alignmentVertical,
      ...alignmentHorizontal,
      ...alignmentDiagonalLeft,
      ...alignmentDiagonalRight,
    ], kingdom));

    //
    validAlignments.add(countValidAlignments([
      ...alignmentDiagonalRight,
      ...alignmentDiagonalLeft,
      ...alignmentHorizontal,
      ...alignmentVertical,
    ], kingdom));

    validAlignments.add(countValidAlignments([
      ...alignmentDiagonalRight,
      ...alignmentDiagonalLeft,
      ...alignmentVertical,
      ...alignmentHorizontal,
    ], kingdom));

    validAlignments.add(countValidAlignments([
      ...alignmentDiagonalLeft,
      ...alignmentDiagonalRight,
      ...alignmentHorizontal,
      ...alignmentVertical,
    ], kingdom));

    validAlignments.add(countValidAlignments([
      ...alignmentDiagonalLeft,
      ...alignmentDiagonalRight,
      ...alignmentVertical,
      ...alignmentHorizontal,
    ], kingdom));

    return extraPoints * validAlignments.reduce(max);
  }
}