import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'board.dart';

const String crown = '\u{1F451}';
const String castle = '\u{1F3F0}';

enum SelectionMode { field, crown, castle }

const gameSet = {
  FieldType.wheat: {'count': 21 + 5, 'maxCrown': 1},
  FieldType.grass: {'count': 10 + 2 + 2, 'maxCrown': 2},
  FieldType.forest: {'count': 16 + 6, 'maxCrown': 1},
  FieldType.water: {'count': 12 + 6, 'maxCrown': 1},
  FieldType.swamp: {'count': 6 + 2 + 2, 'maxCrown': 2},
  FieldType.mine: {'count': 1 + 1 + 3 + 1, 'maxCrown': 3}
};

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(KingdominoScore());
}

class KingdominoScore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kingdomino Score',
      theme:
          ThemeData(primarySwatch: Colors.brown, canvasColor: Colors.blueGrey),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FieldType _selectedType = FieldType.none;
  SelectionMode _selectionMode = SelectionMode.field;
  var _board = Board(5);
  int _score = 0;

  void _onSelectFieldType(FieldType selectedType) {
    setState(() {
      _selectedType = selectedType;
      _selectionMode = SelectionMode.field;
    });
  }

  void _onSelectCrown() {
    setState(() {
      _selectionMode = SelectionMode.crown;
    });
  }

  void _onSelectCastle() {
    setState(() {
      _selectedType = FieldType.castle;
      _selectionMode = SelectionMode.castle;
    });
  }

  _aboutDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white70,
          title: Text('Kingdomino Score'),
          content: const Text('Olivier Drevet - GPL v.3'),
          actions: <Widget>[
            FlatButton(
              child: Icon(
                Icons.done,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _scoreDetailsDialog(BuildContext context) {
    const double fontSize = 25.0;

    var areas = getAreas(_board);

    Widget content;

    if (areas.isEmpty) {
      const String shrug = '\u{1F937}';
      content = Text(shrug,
          textAlign: TextAlign.center, style: TextStyle(fontSize: 50.0));
    } else {
      final String square = '\u{25A0}';
      areas
          .sort((a, b) => (a.crowns * a.fields).compareTo(b.crowns * b.fields));

      var tableRows = <TableRow>[];
      for (var area in areas) {
        var tableCells = <TableCell>[];

        tableCells.add(TableCell(
            child: Align(
          alignment: Alignment.centerRight,
          child: Text('${area.fields}', style: TextStyle(fontSize: fontSize)),
        )));
        tableCells.add(TableCell(
            child: Align(
          alignment: Alignment.centerRight,
          child: Text(square,
              style: TextStyle(
                  fontSize: 20,
                  color: getColorForFieldType(area.type, context))),
        )));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: Text('×', style: TextStyle(fontSize: fontSize)))));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(area.crowns.toString(),
                    style: TextStyle(fontSize: fontSize)))));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(crown, style: TextStyle(fontSize: fontSize)))));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: Text('=', style: TextStyle(fontSize: fontSize)))));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: Text('${area.fields * area.crowns}',
                    style: TextStyle(fontSize: fontSize)))));

        var tableRow = TableRow(children: tableCells);
        tableRows.add(tableRow);

        content = SingleChildScrollView(child: Table(children: tableRows));
      }
    }

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white70,
          content: content,
          actions: <Widget>[
            FlatButton(
              child: Icon(
                Icons.done,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Color getColorForFieldType(FieldType type, BuildContext context) {
    Color color;
    switch (type) {
      case FieldType.none:
        color = Theme.of(context).canvasColor;
        break;
      case FieldType.wheat:
        color = Colors.yellow.shade600;
        break;
      case FieldType.grass:
        color = Colors.lightGreen;
        break;
      case FieldType.forest:
        color = Colors.green.shade800;
        break;
      case FieldType.water:
        color = Colors.blue;
        break;
      case FieldType.mine:
        color = Colors.brown.shade800;
        break;
      case FieldType.swamp:
        color = Colors.grey;
        break;
      case FieldType.castle:
        color = Colors.white;
        break;
      default:
        color = Theme.of(context).canvasColor;
    }

    return color;
  }

  void _onFieldTap(int x, int y) {
    Field field = _board.fields[x][y];
    setState(() {
      switch (_selectionMode) {
        case SelectionMode.field:
          field.type = _selectedType;
          if (field.type == FieldType.castle || field.type == FieldType.none) {
            field.crowns = 0;
          }
          break;
        case SelectionMode.crown:
          if (field.type == FieldType.castle || field.type == FieldType.none)
            break;
          field.crowns++;
          if (field.crowns > gameSet[field.type]['maxCrown']) field.crowns = 0;
          break;
        case SelectionMode.castle:
          //remove previous castle if any
          for (var cx = 0; cx < _board.size; cx++) {
            for (var cy = 0; cy < _board.size; cy++) {
              if (_board.fields[cx][cy].type == FieldType.castle) {
                _board.fields[cx][cy].type = FieldType.none;
                _board.fields[cx][cy].crowns = 0;
              }
            }
          }

          field.type = _selectedType; //should be castle
          field.crowns = 0;
          break;
      }
    });
    _updateScore();
  }

  Widget _buildFields(BuildContext context, int index) {
    int gridStateLength = _board.fields.length;
    int x, y = 0;
    x = (index / gridStateLength).floor();
    y = (index % gridStateLength);
    return GestureDetector(
      onTap: () => _onFieldTap(x, y),
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 0.5)),
          child: _buildField(x, y),
        ),
      ),
    );
  }

  Widget _buildField(int x, int y) {
    Field field = _board.fields[x][y];
    Color color = getColorForFieldType(field.type, context);
    if (field.type == FieldType.castle)
      return Container(
          color: color,
          child: FittedBox(fit: BoxFit.fitWidth, child: Text(castle)));
    else
      return Container(
        color: color,
        child: new LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Text(crown * field.crowns,
              style: TextStyle(fontSize: constraints.maxWidth / 3));
        }),
      );
  }

  Widget _buildBoard() {
    int gridStateLength = _board.fields.length;
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            border: Border(
          right: BorderSide(width: 3.5, color: Colors.blueGrey.shade600),
          bottom: BorderSide(width: 3.5, color: Colors.blueGrey.shade900),
        )),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridStateLength,
          ),
          itemBuilder: _buildFields,
          itemCount: gridStateLength * gridStateLength,
        ),
      ),
    );
  }

  void _updateScore() {
    var areas = getAreas(_board);
    setState(() {
      _score = getScore(areas);
    });
  }

  @override
  Widget build(BuildContext context) {
    var fieldSelection = Wrap(
      children: [
        fieldButton(FieldType.wheat),
        fieldButton(FieldType.grass),
        fieldButton(FieldType.forest),
        fieldButton(FieldType.water),
        fieldButton(FieldType.swamp),
        fieldButton(FieldType.mine),
        fieldButton(FieldType.none),
        crownButton(),
        castleButton()
      ],
    );

    var actions = <Widget>[
      IconButton(
          icon: Icon(_board.size == 5 ? Icons.filter_5 : Icons.filter_7),
          onPressed: () {
            setState(() {
              if (_board.size == 5)
                _board.reSize(7);
              else
                _board.reSize(5);

              _score = 0;
              _onSelectCastle();
            });
          }),
      IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            setState(() {
              _board.erase();
              _score = 0;
              _onSelectCastle();
            });
          }),
      IconButton(icon: Icon(Icons.help), onPressed: () => _aboutDialog(context))
    ];

    return Scaffold(
        appBar: AppBar(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.end, children: actions),
        ),
        bottomNavigationBar: BottomAppBar(
            child: fieldSelection, color: Theme.of(context).primaryColor),
        body: Column(children: <Widget>[
          _buildBoard(),
          Expanded(
            child: FittedBox(
                fit: BoxFit.fitHeight,
                child: InkWell(
                  child: Text(_score.toString(),
                      style: TextStyle(color: Colors.white)),
                  onTap: () => _scoreDetailsDialog(context),
                )),
          )
        ]));
  }

  Widget fieldButton(FieldType type) {
    var selected = Icon(
      Icons.crop_free,
      color: Colors.white,
    );

    return GestureDetector(
        onTap: () => _onSelectFieldType(type),
        child: Container(
          margin: EdgeInsets.all(5.0),
          height: 50.0,
          width: 50.0,
          decoration: BoxDecoration(
              border: Border(
            right: BorderSide(width: 3.5, color: Colors.blueGrey.shade600),
            bottom: BorderSide(width: 3.5, color: Colors.blueGrey.shade900),
          )),
          child: Container(
            color: getColorForFieldType(type, context),
            child:
                _selectionMode == SelectionMode.field && _selectedType == type
                    ? selected
                    : Text(''),
          ),
        ));
  }

  final double margin = 5.0;

  var selectedBorder = BorderSide(
    color: Colors.blueGrey,
    style: BorderStyle.solid,
    width: 0.8,
  );

  Container crownButton() => Container(
      margin: EdgeInsets.all(margin),
      child: OutlineButton(
          borderSide:
              _selectionMode == SelectionMode.crown ? selectedBorder : null,
          onPressed: () => _onSelectCrown(),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Text(crown, style: TextStyle(fontSize: 30.0))));

  Container castleButton() {
    return Container(
        margin: EdgeInsets.all(margin),
        child: OutlineButton(
            borderSide:
                _selectionMode == SelectionMode.castle ? selectedBorder : null,
            onPressed: () => _onSelectCastle(),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Text(castle, style: TextStyle(fontSize: 30.0))));
  }
}
