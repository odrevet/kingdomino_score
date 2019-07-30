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

  void erase() {
    for (var x = 0; x < this.size; x++) {
      for (var y = 0; y < this.size; y++) {
        this.lands[x][y].landType = LandType.none;
        this.lands[x][y].crowns = 0;
      }
    }
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

  void addLandToProperty(int x, int y, Land field, Property property) {
    if (isInBound(x, y, size)) {
      Land checkField = lands[x][y];
      if (checkField.landType == field.landType &&
          checkField.isMarked == false) {
        property.landCount++;
        property.crownCount += checkField.crowns;
        _getAdjacentLand(x, y, property);
      }
    }
  }

  Property _getAdjacentLand(int x, int y, Property property) {
    if (!isInBound(x, y, size)) return null;

    var field = lands[x][y];
    if (field.landType == LandType.castle ||
        field.landType == LandType.none ||
        field.isMarked == true) return null;

    if (property == null) {
      property = Property(field.landType);
      property.landCount++;
      property.crownCount += field.crowns;
    }

    field.isMarked = true;

    addLandToProperty(x, y - 1, field, property);
    addLandToProperty(x, y + 1, field, property);
    addLandToProperty(x - 1, y, field, property);
    addLandToProperty(x + 1, y, field, property);

    return property;
  }
}

class Land {
  LandType landType = LandType.none;
  int crowns = 0;
  bool isMarked = false; //to create properties
  Land(this.landType);
}

////////////////////////////////////////////////
// Score calculation related class and functions

class Property {
  LandType landType;
  int crownCount = 0;
  int landCount = 0;

  Property(this.landType);
}

bool isInBound(int x, int y, int size) {
  return (x >= 0 && x < size && y >= 0 && y < size);
}

int calculateScoreFromProperties(List<Property> properties) {
  int score = 0;
  properties
      .forEach((property) => score += property.landCount * property.crownCount);
  return score;
}
