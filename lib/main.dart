import 'package:flutter/material.dart';
import 'board.dart';

void main() => runApp(MyApp());

enum SelectionMode { field, crown, castle }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  Color getColorForFieldType(FieldType type) {
    Color color;
    switch (type) {
      case FieldType.none:
        color = Colors.black;
        break;
      case FieldType.wheat:
        color = Colors.yellow;
        break;
      case FieldType.grass:
        color = Colors.green;
        break;
      case FieldType.water:
        color = Colors.blue;
        break;
      case FieldType.swamp:
        color = Colors.brown;
        break;
      case FieldType.mine:
        color = Colors.grey;
        break;
      case FieldType.castle:
        color = Colors.white;
        break;
      default:
        color = Colors.black;
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
          if (field.crowns > 3) field.crowns = 0;
          break;
        case SelectionMode.castle:
          //remove previous castle if any
          for (var x = 0; x < _board.size; x++) {
            for (var y = 0; y < _board.size; y++) {
              if (field.type == FieldType.castle) {
                field.type = FieldType.none;
                field.crowns = 0;
              }
            }
          }

          field.type = _selectedType; //should be castle
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
    Color color = getColorForFieldType(_board.fields[x][y].type);
    String crowns = '*' * _board.fields[x][y].crowns;
    return Container(color: color, child: Text(crowns));
  }

  Widget _buildBoard() {
    int gridStateLength = _board.fields.length;
    return Column(children: <Widget>[
      AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2.0)),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridStateLength,
            ),
            itemBuilder: _buildFields,
            itemCount: gridStateLength * gridStateLength,
          ),
        ),
      ),
    ]);
  }

  void _updateScore() {
    var areas = getAreas(_board);
    for (var area in areas) {
      print(
          '${area.fields.toString()} fields and ${area.crowns.toString()} crowns');
    }
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
          icon: Icon(Icons.filter_5),
          onPressed: () {
            setState(() {
              if (_board.size == 5)
                _board.reSize(7);
              else
                _board.reSize(5);
            });
          }),
      IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            setState(() {
              _board.erase();
            });
          })
    ];

    return Scaffold(
        appBar: AppBar(
          title: ButtonBar(children: actions),
        ),
        bottomNavigationBar:
            BottomAppBar(child: fieldSelection, color: Colors.blue),
        body:
            Column(children: <Widget>[_buildBoard(), Text(_score.toString())]));
  }

  IconButton fieldButton(FieldType type) => IconButton(
      icon: Icon(Icons.stop),
      color: getColorForFieldType(type),
      onPressed: () => _onSelectFieldType(type));

  IconButton crownButton() => IconButton(
        icon: Icon(Icons.add_box),
        onPressed: () => _onSelectCrown(),
      );

  IconButton castleButton() => IconButton(
        icon: Icon(Icons.star),
        onPressed: () => _onSelectCastle(),
      );
}

