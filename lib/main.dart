import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'kingdom.dart';
import 'quest.dart';
import 'age_of_giants.dart';

const String crown = '\u{1F451}';
const String castle = '\u{1F3F0}';
final String square = '\u{25A0}';

enum SelectionMode { land, crown, castle }

const Map<LandType, Map<String, dynamic>> gameSet = {
  LandType.castle: {
    'count': 1, //per player
    'crowns': {'max': 0}
  },
  LandType.wheat: {
    'count': 21 + 5,
    'crowns': {'max': 1, 1: 5}
  },
  LandType.grassland: {
    'count': 10 + 2 + 2,
    'crowns': {'max': 2, 1: 2, 2: 2}
  },
  LandType.forest: {
    'count': 16 + 6,
    'crowns': {'max': 1, 1: 6}
  },
  LandType.lake: {
    'count': 12 + 6,
    'crowns': {'max': 1, 1: 6}
  },
  LandType.swamp: {
    'count': 6 + 2 + 2,
    'crowns': {'max': 2, 1: 2, 2: 2}
  },
  LandType.mine: {
    'count': 1 + 1 + 3 + 1,
    'crowns': {'max': 3, 1: 1, 2: 3, 3: 1}
  }
};

Color getColorForLandType(LandType type, [BuildContext context]) {
  Color color;
  switch (type) {
    case LandType.none:
      color = context == null ? Colors.black : Theme.of(context).canvasColor;
      break;
    case LandType.wheat:
      color = Colors.yellow.shade600;
      break;
    case LandType.grassland:
      color = Colors.lightGreen;
      break;
    case LandType.forest:
      color = Colors.green.shade800;
      break;
    case LandType.lake:
      color = Colors.blue;
      break;
    case LandType.mine:
      color = Colors.brown.shade800;
      break;
    case LandType.swamp:
      color = Colors.grey;
      break;
    case LandType.castle:
      color = Colors.white;
      break;
    default:
      color = context == null ? Colors.black : Theme.of(context).canvasColor;
  }

  return color;
}

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(KingdominoScore());
}

class KingdominoScore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kingdomino Score',
      theme: ThemeData(
          primarySwatch: Colors.brown,
          canvasColor: Colors.blueGrey,
          fontFamily: 'Augusta'),
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
  LandType _selectedType = LandType.none;
  SelectionMode _selectionMode = SelectionMode.land;
  var _board = Kingdom(5);
  int _scoreProperty = 0;
  int _scoreQuest = 0;
  int _score = 0;

  bool aog = false; // Age of Giants extension
  List<Quest> _quests = []; //standard : 0, 1 or 2, aog : 2
  List<RichText> _warnings = [];

  @override
  initState() {
    super.initState();
    _onSelectCastle();
  }

  Map<LandType, Map<String, dynamic>> _getGameSet() {
    if (aog == false) {
      return gameSet;
    } else {
      return gameAogSet;
    }
  }

  void _onSelectLandType(LandType selectedType) {
    setState(() {
      _selectedType = selectedType;
      _selectionMode = SelectionMode.land;
    });
  }

  void _onSelectCrown() {
    setState(() {
      _selectionMode = SelectionMode.crown;
    });
  }

  void _onSelectCastle() {
    setState(() {
      _selectedType = LandType.castle;
      _selectionMode = SelectionMode.castle;
    });
  }

  _warningsDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white70,
          content: SingleChildScrollView(child: Column(children: _warnings)),
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

  static final harmonyWidget = HarmonyWidget();
  static final middleKingdomWidget = MiddleKingdomWidget();

  static final localBusinessWheatWidget =
      LocalBusinessWidget(LocalBusiness(LandType.wheat));
  static final localBusinessGrasslandWidget =
      LocalBusinessWidget(LocalBusiness(LandType.grassland));
  static final localBusinessForestWidget =
      LocalBusinessWidget(LocalBusiness(LandType.forest));
  static final localBusinessLakeWidget =
      LocalBusinessWidget(LocalBusiness(LandType.lake));
  static final localBusinessMineWidget =
      LocalBusinessWidget(LocalBusiness(LandType.mine));
  static final localBusinessSwampWidget =
      LocalBusinessWidget(LocalBusiness(LandType.swamp));

  static final fourCornersWheatWidget =
      FourCornersWidget(FourCorners(LandType.wheat));
  static final fourCornersGrasslandWidget =
      FourCornersWidget(FourCorners(LandType.grassland));
  static final fourCornersForestWidget =
      FourCornersWidget(FourCorners(LandType.forest));
  static final fourCornersLakeWidget =
      FourCornersWidget(FourCorners(LandType.lake));
  static final fourCornersMineWidget =
      FourCornersWidget(FourCorners(LandType.mine));
  static final fourCornersSwampWidget =
      FourCornersWidget(FourCorners(LandType.swamp));

  static final lostCornerWidget = LostCornerWidget();
  static final folieDesGrandeursWidget = FolieDesGrandeursWidget();
  static final bleakKingWidget = BleakKingWidget();

  _questDialogAddOption(List<Widget> options, QuestWidget questWidget) {
    options.add(
      SimpleDialogOption(
        child: _quests.contains(questWidget.quest)
            ? Container(
                decoration: new BoxDecoration(
                    border: new Border.all(color: Colors.blueAccent)),
                child: questWidget)
            : questWidget,
        onPressed: () {
          setState(() {
            if (_quests.contains(questWidget.quest))
              _quests.remove(questWidget.quest);
            else if (_quests.length < 2) _quests.add(questWidget.quest);
          });

          _updateScoreQuest();
          _updateScore();
        },
      ),
    );
  }

  _questsDialog(BuildContext context) {
    var options = <Widget>[];

    _questDialogAddOption(options, harmonyWidget);
    _questDialogAddOption(options, middleKingdomWidget);

    if (aog == true) {
      _questDialogAddOption(options, localBusinessWheatWidget);
      _questDialogAddOption(options, localBusinessGrasslandWidget);
      _questDialogAddOption(options, localBusinessForestWidget);
      _questDialogAddOption(options, localBusinessLakeWidget);
      _questDialogAddOption(options, localBusinessMineWidget);
      _questDialogAddOption(options, localBusinessSwampWidget);

      _questDialogAddOption(options, fourCornersWheatWidget);
      _questDialogAddOption(options, fourCornersGrasslandWidget);
      _questDialogAddOption(options, fourCornersForestWidget);
      _questDialogAddOption(options, fourCornersLakeWidget);
      _questDialogAddOption(options, fourCornersMineWidget);
      _questDialogAddOption(options, fourCornersSwampWidget);

      _questDialogAddOption(options, lostCornerWidget);
      _questDialogAddOption(options, folieDesGrandeursWidget);
      _questDialogAddOption(options, bleakKingWidget);
    }

    SimpleDialog dialog = SimpleDialog(
      children: options,
    );

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

  _aboutDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white70,
          title: Text('Kingdomino Score',
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: 30.0,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 3.0,
                      color: Color.fromARGB(255, 255, 255, 255),
                    )
                  ])),
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

    var properties = _board.getProperties();

    Widget content;

    if (properties.isEmpty) {
      const String shrug = '\u{1F937}';
      content = Text(shrug,
          textAlign: TextAlign.center, style: TextStyle(fontSize: 50.0));
    } else {
      properties.sort((property, propertyToComp) =>
          (property.crownCount * property.landCount)
              .compareTo(propertyToComp.crownCount * propertyToComp.landCount));

      var tableRows = <TableRow>[];
      for (var property in properties) {
        var tableCells = <TableCell>[];

        tableCells.add(TableCell(
            child: Align(
          alignment: Alignment.centerRight,
          child: Text('${property.landCount}',
              style: TextStyle(fontSize: fontSize)),
        )));
        tableCells.add(TableCell(
            child: Align(
          alignment: Alignment.centerRight,
          child: Text(square,
              style: TextStyle(
                  fontSize: 20,
                  color: getColorForLandType(property.landType, context))),
        )));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: Text('x', style: TextStyle(fontSize: fontSize)))));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(property.crownCount.toString(),
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
                child: Text('${property.landCount * property.crownCount}',
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

  void _onFieldTap(int x, int y) {
    Land field = _board.lands[x][y];
    setState(() {
      switch (_selectionMode) {
        case SelectionMode.land:
          field.landType = _selectedType;
          field.crowns = 0;
          break;
        case SelectionMode.crown:
          if (field.landType == LandType.castle ||
              field.landType == LandType.none) break;
          field.crowns++;
          if (field.crowns > _getGameSet()[field.landType]['crowns']['max'])
            field.crowns = 0;
          break;
        case SelectionMode.castle:
          //remove previous castle if any
          for (var cx = 0; cx < _board.size; cx++) {
            for (var cy = 0; cy < _board.size; cy++) {
              if (_board.lands[cx][cy].landType == LandType.castle) {
                _board.lands[cx][cy].landType = LandType.none;
                _board.lands[cx][cy].crowns = 0;
              }
            }
          }

          field.landType = _selectedType; //should be castle
          field.crowns = 0;
          break;
      }
    });

    _clearWarnings();
    _checkBoard();
    _updateScores();
  }

  Widget _buildLand(int x, int y) {
    Land land = _board.lands[x][y];
    Color color = getColorForLandType(land.landType, context);
    if (land.landType == LandType.castle)
      return Container(
          color: color,
          child: FittedBox(fit: BoxFit.fitWidth, child: Text(castle)));
    else
      return Container(
        color: color,
        child: new LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Text(crown * land.crowns,
                  style: TextStyle(fontSize: constraints.maxWidth / 3));
            }),
      );
  }

  Widget _buildLands(BuildContext context, int index) {
    int gridStateLength = _board.lands.length;
    int x, y = 0;
    x = (index / gridStateLength).floor();
    y = (index % gridStateLength);
    return GestureDetector(
      onTap: () => _onFieldTap(x, y),
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 0.5)),
          child: _buildLand(x, y),
        ),
      ),
    );
  }

  Widget _buildBoard() {
    int gridStateLength = _board.lands.length;
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
          itemBuilder: _buildLands,
          itemCount: gridStateLength * gridStateLength,
        ),
      ),
    );
  }

  void _clearWarnings() {
    setState(() {
      _warnings.clear();
    });
  }

  //check if the board is conform, if not set warnings
  void _checkBoard() {
    //check if more tile in the board than in the gameSet
    for (var fieldType in LandType.values) {
      if (fieldType == LandType.none) continue;

      var count = _board.lands
          .expand((i) => i)
          .toList()
          .where((field) => field.landType == fieldType)
          .length;
      if (count > _getGameSet()[fieldType]['count']) {
        setState(() {
          _warnings.add(RichText(
              text: TextSpan(
                  text: '$count ',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  children: [
                TextSpan(
                    text: square,
                    style: TextStyle(
                        fontSize: 20,
                        color: getColorForLandType(fieldType, context))),
                TextSpan(
                    text: ' > ${_getGameSet()[fieldType]['count']}',
                    style: TextStyle(color: Colors.black, fontSize: 20))
              ])));
        });
      }

      //check for too many tile with given crowns
      for (var crownsCounter = 1;
          crownsCounter <= _getGameSet()[fieldType]['crowns']['max'];
          crownsCounter++) {
        var count = _board.lands
            .expand((i) => i)
            .toList()
            .where((field) =>
                field.landType == fieldType && field.crowns == crownsCounter)
            .length;

        if (count > _getGameSet()[fieldType]['crowns'][crownsCounter]) {
          setState(() {
            _warnings.add(RichText(
                text: TextSpan(
                    text: '$count ',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    children: [
                  TextSpan(
                      text: square,
                      style: TextStyle(
                          fontSize: 20,
                          color: getColorForLandType(fieldType, context))),
                  TextSpan(
                      text: crown * crownsCounter,
                      style: TextStyle(fontSize: 20)),
                  TextSpan(
                      text:
                          ' > ${_getGameSet()[fieldType]['crowns'][crownsCounter]}',
                      style: TextStyle(color: Colors.black, fontSize: 20))
                ])));
          });
        }
      }
    }
  }

  void _updateScoreQuest() {
    var scoreQuest = 0;

    for (var i = 0; i < _quests.length; i++) {
      scoreQuest += _quests[i].getPoints(_board);
    }

    setState(() {
      _scoreQuest = scoreQuest;
    });
  }

  void _updateScores() {
    _updateScoreProperty();
    _updateScoreQuest();
    _updateScore();
  }

  void _updateScoreProperty() {
    var properties = _board.getProperties();
    setState(() {
      _scoreProperty = calculateScoreFromProperties(properties);
    });
  }

  void _updateScore() {
    setState(() {
      _score = _scoreProperty + _scoreQuest;
    });
  }

  void _resetScores() {
    setState(() {
      _score = _scoreProperty = _scoreQuest = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    var fieldSelection = Wrap(
      children: [
        fieldButton(LandType.wheat),
        fieldButton(LandType.grassland),
        fieldButton(LandType.forest),
        fieldButton(LandType.lake),
        fieldButton(LandType.swamp),
        fieldButton(LandType.mine),
        fieldButton(LandType.none),
        crownButton(),
        castleButton()
      ],
    );

    var actions = <Widget>[
      MaterialButton(
          minWidth: 30,
          onPressed: () {
            setState(() {
              aog = !aog;

              _quests.clear();
              _updateScoreQuest();
              _updateScore();
            });
          },
          child: Container(
              child: Text('AG',
                  style: TextStyle(
                      fontSize: 30, color: aog ? Colors.red : Colors.white)))),
      Stack(
        children: <Widget>[
          MaterialButton(
              minWidth: 30,
              onPressed: () => _questsDialog(context),
              child: Container(
                  child: Text(shield, style: TextStyle(fontSize: 30)))),
          Positioned(
            right: 5,
            top: 10,
            child: new Container(
              padding: EdgeInsets.all(1),
              decoration: new BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: BoxConstraints(
                minWidth: 12,
                minHeight: 12,
              ),
              child: new Text(
                '${_quests.length}',
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
      IconButton(
          icon: Icon(_board.size == 5 ? Icons.filter_5 : Icons.filter_7),
          onPressed: () {
            setState(() {
              if (_board.size == 5)
                _board.reSize(7);
              else
                _board.reSize(5);

              _resetScores();
              _clearWarnings();
              _onSelectCastle();
            });
          }),
      IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            setState(() {
              _board.erase();
              _clearWarnings();
              _resetScores();
              _onSelectCastle();
            });
          }),
      IconButton(icon: Icon(Icons.help), onPressed: () => _aboutDialog(context))
    ];

    if (_warnings.isNotEmpty) {
      actions.insert(
          0,
          Stack(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.warning),
                  onPressed: () => _warningsDialog(context)),
              Positioned(
                right: 5,
                top: 10,
                child: new Container(
                  padding: EdgeInsets.all(1),
                  decoration: new BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: new Text(
                    '${_warnings.length}',
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ));
    }

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

  Widget fieldButton(LandType type) {
    var selected = Icon(
      Icons.crop_free,
      color: Colors.white,
    );

    return GestureDetector(
        onTap: () => _onSelectLandType(type),
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
            color: getColorForLandType(type, context),
            child: _selectionMode == SelectionMode.land && _selectedType == type
                ? selected
                : Text(''),
          ),
        ));
  }

  final double margin = 5.0;

  var selectedBorder = BorderSide(
    color: Colors.red,
    style: BorderStyle.solid,
    width: 1.0,
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
