import 'land.dart';
import 'property.dart';

class Kingdom {
  int size = 5;
  List<List<Land>> _lands = [];

  List<List<Land>> getLands() {
    return _lands;
  }

  Land? getLand(int y, int x) {
    if(y < 0 || x < 0 || x > this.size || y > this.size){
      return null;
    }

    return _lands[x][y];
  }

  void setLand(int y, int x, Land land) {
    if(y < 0 || x < 0 || x > this.size || y > this.size){
      return null;
    }

    _lands[x][y].landType = land.landType;
    _lands[x][y].crowns = land.crowns;
  }

  Kingdom(this.size) {
    for (var i = 0; i < size; i++) {
      this._lands.add(List<Land>.generate(size, (_) => Land()));
    }
  }

  void reSize(int size) {
    this.size = size;
    this._lands = [];
    for (var i = 0; i < size; i++) {
      this._lands.add(List<Land>.generate(size, (_) => Land()));
    }
  }

  void clear() {
    _lands.expand((i) => i).toList().forEach((land) {
      land.landType = null;
      land.crowns = 0;
      land.giants = 0;
      land.hasResource = false;
      land.courtierType = null;
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
      Land? landToAdd = getLand(x, y);
      if (landToAdd != null && landToAdd.landType == land.landType && landToAdd.isMarked == false) {
        property.landCount++;
        property.crownCount += landToAdd.getCrowns();
        property.giantCount += landToAdd.giants;
        _getAdjacentLand(x, y, property);
      }
    }
  }

  Property? _getAdjacentLand(int x, int y, Property? property) {
    if (!isInBound(x, y)) return null;

    Land? land = getLand(x, y);
    if (land == null || land.landType == LandType.castle ||
        land.landType == null ||
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

