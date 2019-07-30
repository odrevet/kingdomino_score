enum LandType { none, wheat, grassland, forest, lake, swamp, mine, castle }

class Kingdom {
  int size = 5;
  List<List<Land>> lands;

  Kingdom(this.size) {
    this.lands = [];
    for (var i = 0; i < size; i++) {
      this.lands.add(List<Land>.generate(size, (_) => Land(LandType.none)));
    }
  }

  void reSize(int size) {
    this.size = size;
    this.lands = [];
    for (var i = 0; i < size; i++) {
      this.lands.add(List<Land>.generate(size, (_) => Land(LandType.none)));
    }
  }

  void clear() {
    lands.expand((i) => i).toList().forEach((land) {
      land.landType = LandType.none;
      land.crowns = 0;
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
    lands.expand((i) => i).toList().forEach((land) => land.isMarked = false);

    return properties;
  }


   ///add land at x y to the property if it's landType is the same as land
  void _addLandToProperty(int x, int y, Land land, Property property) {
    if (isInBound(x, y)) {
      Land landToAdd = lands[x][y];
      if (landToAdd.landType == land.landType &&
          landToAdd.isMarked == false) {
        property.landCount++;
        property.crownCount += landToAdd.getCrowns();
        _getAdjacentLand(x, y, property);
      }
    }
  }

  Property _getAdjacentLand(int x, int y, Property property) {
    if (!isInBound(x, y)) return null;

    var land = lands[x][y];
    if (land.landType == LandType.castle ||
        land.landType == LandType.none ||
        land.isMarked == true) return null;

    if (property == null) {
      property = Property(land.landType);
      property.landCount++;
      property.crownCount += land.getCrowns();
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

class Land {
  LandType landType = LandType.none;
  int crowns = 0;
  bool isMarked = false; //to create properties
  bool hasGiant = false; //AoG extension

  ///set crowns to 0 and hasGiant to false
  void reset(){
    crowns = 0;
    hasGiant = false;
  }

  /// return 0 is hasGiant is true
  /// return crowns otherwise
  int getCrowns(){
    return hasGiant ? 0 : crowns;
  }

  Land(this.landType);
}

class Property {
  LandType landType;
  int crownCount = 0;
  int landCount = 0;

  Property(this.landType);
}
