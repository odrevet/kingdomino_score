import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'kingdom.dart';
import 'kingdomWidget.dart';
import 'quest.dart';
import 'age_of_giants.dart';
import 'questDialog.dart';

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
      home: MainWidget(),
    );
  }
}

class MainWidget extends StatefulWidget {
  MainWidget({Key key}) : super(key: key);

  @override
  MainWidgetState createState() => MainWidgetState();
}

class MainWidgetState extends State<MainWidget> {
  LandType selectedLandType = LandType.none;
  SelectionMode selectionMode = SelectionMode.land;
  var _kingdom = Kingdom(5);
  int _scoreProperty = 0;
  int _scoreQuest = 0;
  int _score = 0;

  bool aog = false; // Age of Giants extension
  List<Quest> quests = []; //standard : 0, 1 or 2, aog : 2
  List<RichText> _warnings = [];

  @override
  initState() {
    super.initState();
    _onSelectCastle();
  }

  Map<LandType, Map<String, dynamic>> getGameSet() {
    if (aog == false) {
      return gameSet;
    } else {
      return gameAogSet;
    }
  }

  void _onSelectLandType(LandType selectedType) {
    setState(() {
      selectedLandType = selectedType;
      selectionMode = SelectionMode.land;
    });
  }

  void _onSelectCrown() {
    setState(() {
      selectionMode = SelectionMode.crown;
    });
  }

  void _onSelectCastle() {
    setState(() {
      selectedLandType = LandType.castle;
      selectionMode = SelectionMode.castle;
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

    var properties = _kingdom.getProperties();

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

  void clearWarnings() {
    setState(() {
      _warnings.clear();
    });
  }

  ///check if the kingdom is conform, if not set warnings
  void checkKingdom() {
    //check if more tile in the kingdom than in the gameSet
    for (var landType in LandType.values) {
      if (landType == LandType.none) continue;

      var count = _kingdom.lands
          .expand((i) => i)
          .toList()
          .where((land) => land.landType == landType)
          .length;
      if (count > getGameSet()[landType]['count']) {
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
                        color: getColorForLandType(landType, context))),
                TextSpan(
                    text: ' > ${getGameSet()[landType]['count']}',
                    style: TextStyle(color: Colors.black, fontSize: 20))
              ])));
        });
      }

      //check for too many tile with given crowns
      for (var crownsCounter = 1;
          crownsCounter <= getGameSet()[landType]['crowns']['max'];
          crownsCounter++) {
        var count = _kingdom.lands
            .expand((i) => i)
            .toList()
            .where((land) =>
                land.landType == landType && land.crowns == crownsCounter)
            .length;

        if (count > getGameSet()[landType]['crowns'][crownsCounter]) {
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
                          color: getColorForLandType(landType, context))),
                  TextSpan(
                      text: crown * crownsCounter,
                      style: TextStyle(fontSize: 20)),
                  TextSpan(
                      text:
                          ' > ${getGameSet()[landType]['crowns'][crownsCounter]}',
                      style: TextStyle(color: Colors.black, fontSize: 20))
                ])));
          });
        }
      }
    }
  }

  void updateScoreQuest() {
    var scoreQuest = 0;

    for (var i = 0; i < quests.length; i++) {
      scoreQuest += quests[i].getPoints(_kingdom);
    }

    setState(() {
      _scoreQuest = scoreQuest;
    });
  }

  void updateScores() {
    updateScoreProperty();
    updateScoreQuest();
    updateScore();
  }

  void updateScoreProperty() {
    var properties = _kingdom.getProperties();
    setState(() {
      _scoreProperty = _kingdom.calculateScoreFromProperties(properties);
    });
  }

  void updateScore() {
    setState(() {
      _score = _scoreProperty + _scoreQuest;
    });
  }

  void resetScores() {
    setState(() {
      _score = _scoreProperty = _scoreQuest = 0;
    });
  }

  Widget landButton(LandType type) {
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
            child: selectionMode == SelectionMode.land && selectedLandType == type
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
          selectionMode == SelectionMode.crown ? selectedBorder : null,
          onPressed: () => _onSelectCrown(),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Text(crown, style: TextStyle(fontSize: 30.0))));

  Container castleButton() {
    return Container(
        margin: EdgeInsets.all(margin),
        child: OutlineButton(
            borderSide:
            selectionMode == SelectionMode.castle ? selectedBorder : null,
            onPressed: () => _onSelectCastle(),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Text(castle, style: TextStyle(fontSize: 30.0))));
  }

  @override
  Widget build(BuildContext context) {
    var landSelection = Wrap(
      children: [
        landButton(LandType.wheat),
        landButton(LandType.grassland),
        landButton(LandType.forest),
        landButton(LandType.lake),
        landButton(LandType.swamp),
        landButton(LandType.mine),
        landButton(LandType.none),
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

              quests.clear();
              updateScoreQuest();
              updateScore();
            });
          },
          child: Container(
              child: Text('AG',
                  style: TextStyle(
                      fontSize: 30, color: aog ? Colors.red : Colors.white)))),
    QuestDialogWidget(this, _kingdom)
      ,
      IconButton(
          icon: Icon(_kingdom.size == 5 ? Icons.filter_5 : Icons.filter_7),
          onPressed: () {
            setState(() {
              if (_kingdom.size == 5)
                _kingdom.reSize(7);
              else
                _kingdom.reSize(5);

              resetScores();
              clearWarnings();
              _onSelectCastle();
            });
          }),
      IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            setState(() {
              _kingdom.clear();
              clearWarnings();
              resetScores();
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
            child: landSelection, color: Theme.of(context).primaryColor),
        body: Column(children: <Widget>[
            KingdomWidget(this, _kingdom),
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
}
