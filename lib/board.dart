enum LandType { none, wheat, grassland, forest, lake, swamp, mine, castle }

class Board {
  int size = 5;
  List<List<Land>> lands;

  Board(this.size) {
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

void addLandToProperty(
    int x, int y, Board board, Land field, Property property) {
  if (isInBound(x, y, board.size)) {
    Land checkField = board.lands[x][y];
    if (checkField.landType == field.landType && checkField.isMarked == false) {
      property.landCount++;
      property.crownCount += checkField.crowns;
      getAdjacentFields(x, y, board, property);
    }
  }
}

Property getAdjacentFields(int x, int y, Board board, Property property) {
  if (!isInBound(x, y, board.size)) return null;

  var field = board.lands[x][y];
  if (field.landType == LandType.castle ||
      field.landType == LandType.none ||
      field.isMarked == true) return null;

  if (property == null) {
    property = Property(field.landType);
    property.landCount++;
    property.crownCount += field.crowns;
  }

  field.isMarked = true;

  addLandToProperty(x, y - 1, board, field, property);
  addLandToProperty(x, y + 1, board, field, property);
  addLandToProperty(x - 1, y, board, field, property);
  addLandToProperty(x + 1, y, board, field, property);

  return property;
}

List<Property> getProperties(Board board) {
  var properties = <Property>[];

  for (var x = 0; x < board.size; x++) {
    for (var y = 0; y < board.size; y++) {
      var property = getAdjacentFields(x, y, board, null);
      if (property != null) {
        properties.add(property);
      }
    }
  }

  //reset marked status
  for (var x = 0; x < board.size; x++) {
    for (var y = 0; y < board.size; y++) {
      board.lands[x][y].isMarked = false;
    }
  }

  return properties;
}

int getScore(List<Property> properties) {
  int score = 0;
  for (var property in properties) {
    score += property.landCount * property.crownCount;
  }
  return score;
}
