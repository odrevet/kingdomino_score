enum FieldType { none, wheat, grass, forest, water, swamp, mine, castle }

class Board {
  int size = 5;
  List<List<Field>> fields;

  Board(this.size) {
    this.fields = [];
    for (var i = 0; i < size; i++) {
      this.fields.add(List<Field>.generate(size, (_) => Field(FieldType.none)));
    }
  }

  void reSize(int size) {
    this.size = size;
    this.fields = [];
    for (var i = 0; i < size; i++) {
      this.fields.add(List<Field>.generate(size, (_) => Field(FieldType.none)));
    }
  }

  void erase() {
    for (var x = 0; x < this.size; x++) {
      for (var y = 0; y < this.size; y++) {
        this.fields[x][y].type = FieldType.none;
        this.fields[x][y].crowns = 0;
      }
    }
  }
}

class Field {
  FieldType type = FieldType.none;
  int crowns = 0;
  bool isMarked = false; //to create areas
  Field(this.type);
}

////////////////////////////////////////////////
// Score calculation related class and functions

class Area {
  FieldType type;
  int crowns = 0;
  int fields = 0;

  Area(this.type);
}

bool isInBound(int x, int y, int size) {
  return (x >= 0 && x < size && y >= 0 && y < size);
}

void addFieldToArea(int x, int y, Board board, Field field, Area area) {
  if (isInBound(x, y, board.size)) {
    Field checkField = board.fields[x][y];
    if (checkField.type == field.type && checkField.isMarked == false) {
      area.fields++;
      area.crowns += checkField.crowns;
      getAdjacentFields(x, y, board, area);
    }
  }
}

Area getAdjacentFields(int x, int y, Board board, Area area) {
  if (!isInBound(x, y, board.size)) return null;

  var field = board.fields[x][y];
  if (field.type == FieldType.castle ||
      field.type == FieldType.none ||
      field.isMarked == true) return null;

  if (area == null) {
    area = Area(field.type);
    area.fields++;
    area.crowns += field.crowns;
  }

  field.isMarked = true;

  addFieldToArea(x, y - 1, board, field, area);
  addFieldToArea(x, y + 1, board, field, area);
  addFieldToArea(x - 1, y, board, field, area);
  addFieldToArea(x + 1, y, board, field, area);

  return area;
}

List<Area> getAreas(Board board) {
  var areas = <Area>[];

  for (var x = 0; x < board.size; x++) {
    for (var y = 0; y < board.size; y++) {
      var area = getAdjacentFields(x, y, board, null);
      if (area != null) {
        areas.add(area);
      }
    }
  }

  //reset marked status
  for (var x = 0; x < board.size; x++) {
    for (var y = 0; y < board.size; y++) {
      board.fields[x][y].isMarked = false;
    }
  }

  return areas;
}

int getScore(List<Area> areas) {
  int score = 0;
  for (var area in areas) {
    score += area.fields * area.crowns;
  }
  return score;
}
