import 'package:flutter/material.dart';
import 'board.dart';

void main() => runApp(MyApp());

enum SelectionMode { field, crown, castle }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kingdomino Score',
      theme:
          ThemeData(primarySwatch: Colors.brown, canvasColor: Colors.blueGrey),
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

  _aboutDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Kingdomino Score Count'),
          content: const Text('Olivier Drevet - GPL v.3'),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
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
    var areas = getAreas(_board);
    String text = '';

    for(var area in areas){
      text += '${area.fields} * ${area.crowns} = ${area.fields * area.crowns}\n';
    }

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(''),
          content: Text(text),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
        color = Colors.lightGreen;
        break;
      case FieldType.forest:
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

    var crowns = List<Widget>.generate(_board.fields[x][y].crowns,
        (_) => Image.asset('assets/crown.png', width: 20.0, height: 20.0));
    return Container(color: color, child: Wrap(children: crowns));
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
            });
          }),
      IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            setState(() {
              _board.erase();
            });
          }),
      IconButton(icon: Icon(Icons.help), onPressed: () => _aboutDialog(context))
    ];

    return Scaffold(
        appBar: AppBar(
          title: ButtonBar(children: actions),
        ),
        bottomNavigationBar: BottomAppBar(
            child: fieldSelection, color: Theme.of(context).primaryColor),
        body: Column(children: <Widget>[
          _buildBoard(),
          InkWell(
            child: Text(_score.toString(), style: TextStyle(height: 5.0)),
            onTap: () => _scoreDetailsDialog(context),
          )
        ]));
  }

  Widget fieldButton(FieldType type) => GestureDetector(
      onTap: () => _onSelectFieldType(type),
      child: Container(
        margin: EdgeInsets.all(5.0),
        height: 50.0,
        width: 50.0,
        decoration:
            BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
        child: Container(
          color: getColorForFieldType(type),
          child: Text(''),
        ),
      ));

  FlatButton crownButton() => FlatButton(
      onPressed: () => _onSelectCrown(),
      padding: EdgeInsets.all(0.0),
      child: Image.asset('assets/crown.png', width: 20.0, height: 20.0));

  IconButton castleButton() => IconButton(
        icon: Icon(Icons.star),
        onPressed: () => _onSelectCastle(),
      );
}
