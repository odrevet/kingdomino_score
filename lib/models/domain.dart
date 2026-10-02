import 'kingdom.dart';
import 'land.dart';

class Domain {
  final LandType landType;
  final int size;
  final Set<int> cells;
  final int crownCount;
  final int anchor;

  const Domain({
    required this.landType,
    required this.size,
    required this.cells,
    required this.crownCount,
    required this.anchor,
  });

  int get landCount => cells.length;

  int get score => landCount * crownCount;

  int get anchorRow => anchor ~/ size;

  int get anchorCol => anchor % size;

  bool contains(int row, int col) {
    if (row < 0 || col < 0 || row >= size || col >= size) return false;
    return cells.contains(row * size + col);
  }
}

extension KingdomDomains on Kingdom {
  List<Domain> computeDomains() {
    final n = kingdomSize.size;
    final visited = List.generate(n, (_) => List<bool>.filled(n, false));
    final domains = <Domain>[];
    const directions = [
      [1, 0],
      [-1, 0],
      [0, 1],
      [0, -1],
    ];

    for (var r = 0; r < n; r++) {
      for (var c = 0; c < n; c++) {
        if (visited[r][c]) continue;
        final start = getLand(r, c);
        if (start == null ||
            start.landType == LandType.empty ||
            start.landType == LandType.castle) {
          continue;
        }

        final cells = <int>{};
        var crowns = 0;
        final stack = <List<int>>[
          [r, c],
        ];
        visited[r][c] = true;

        while (stack.isNotEmpty) {
          final current = stack.removeLast();
          final cr = current[0];
          final cc = current[1];
          final land = getLand(cr, cc)!;
          cells.add(cr * n + cc);
          crowns += isSkulled(cr, cc)
              ? 0
              : land.getCrowns() + gemCrownBonus(cr, cc);

          for (final d in directions) {
            final nr = cr + d[0];
            final nc = cc + d[1];
            if (!isInBound(nr, nc) || visited[nr][nc]) continue;
            final neighbor = getLand(nr, nc);
            if (neighbor == null || neighbor.landType != start.landType) {
              continue;
            }
            visited[nr][nc] = true;
            stack.add([nr, nc]);
          }
        }

        domains.add(
          Domain(
            landType: start.landType,
            size: n,
            cells: cells,
            crownCount: crowns,
            anchor: r * n + c,
          ),
        );
      }
    }

    return domains;
  }
}