import 'kingdom.dart';
import 'land.dart';
import 'property.dart';

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

  factory Domain.fromProperty(Property property, int size) {
    final first = property.cells.first;
    return Domain(
      landType: property.landType!,
      size: size,
      cells: {for (final cell in property.cells) cell.$1 * size + cell.$2},
      crownCount: property.crownCount,
      anchor: first.$1 * size + first.$2,
    );
  }

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
    return getProperties()
        .map((property) => Domain.fromProperty(property, kingdomSize.size))
        .toList();
  }
}
