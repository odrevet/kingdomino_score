import 'land.dart';
import 'property.dart';

class Kingdom {
  int size = 5;
  List<List<Land>> _lands = [];

  List<List<Land>> getLands() {
    return _lands;
  }

  Land getLand(int y, int x) {
    return _lands[x][y];
  }

  Kingdom(this.size) {
    for (var i = 0; i < size; i++) {
      this._lands.add(List<Land>.generate(size, (_) => Land(LandType.none)));
    }
  }

  void reSize(int size) {
    this.size = size;
    this._lands = [];
    for (var i = 0; i < size; i++) {
      this._lands.add(List<Land>.generate(size, (_) => Land(LandType.none)));
    }
  }

  void clear() {
    _lands.expand((i) => i).toList().forEach((land) {
      land.landType = LandType.none;
      land.crowns = 0;
      land.giants = 0;
    });
  }

  List<Property> getProperties() {
    var properties = <Property>[];

    for (var x = 0; x < size; x++) {
      for (var y = 0; y < size; y++) {
        var property = _getAdjacentLand(x, y, null);
        if (property != null) {
          properties.add(property);
        }
      }
    }

    //reset marked status
    _lands.expand((i) => i).toList().forEach((land) => land.isMarked = false);

    return properties;
  }

  ///add land at x y to the property if it's landType is the same as land
  void _addLandToProperty(int x, int y, Land land, Property property) {
    if (isInBound(x, y)) {
      Land landToAdd = getLand(x, y);
      if (landToAdd.landType == land.landType && landToAdd.isMarked == false) {
        property.landCount++;
        property.crownCount += landToAdd.getCrowns();
        property.giantCount += landToAdd.giants;
        _getAdjacentLand(x, y, property);
      }
    }
  }

  Property? _getAdjacentLand(int x, int y, Property? property) {
    if (!isInBound(x, y)) return null;

    var land = getLand(x, y);
    if (land.landType == LandType.castle ||
        land.landType == LandType.none ||
        land.isMarked == true) return null;

    if (property == null) {
      property = Property(land.landType);
      property.landCount++;
      property.crownCount += land.getCrowns();
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
    properties.forEach(
        (property) => score += property.landCount * property.crownCount);
    return score;
  }

  bool isInBound(int x, int y) {
    return (x >= 0 && x < size && y >= 0 && y < size);
  }
}

