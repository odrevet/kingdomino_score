import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'ageOfGiants.dart';
import 'kingdom.dart';
import 'kingdomWidget.dart';
import 'quest.dart';
import 'questDialog.dart';

const String crown = '\u{1F451}';
const String castle = '\u{1F3F0}';
final String square = '\u{25A0}';

enum SelectionMode { land, crown, castle, giant }

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

class Warning {
  int leftOperand;
  LandType landType;
  int crown;
  String operator;
  int rightOperand;

  Warning(this.leftOperand, this.landType, this.crown, this.operator,
      this.rightOperand);
}

class KingdominoScore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kingdomino Score',
      theme: ThemeData(
          primarySwatch: Colors.brown,
          canvasColor: Colors.blueGrey,
          fontFamily: 'HammersmithOne'),
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
  var groupWarning = AutoSizeGroup();
  var groupScore = AutoSizeGroup();

  var kingdom = Kingdom(5);
  int _scoreProperty = 0;
  int _scoreQuest = 0;
  int _score = 0;

  bool aog = false; // Age of Giants extension
  List<Quest> quests = []; //standard : 0, 1 or 2, aog : 2
  List<Warning> _warnings = [];

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
    if (selectedType == LandType.castle)
      _onSelectCastle();
    else
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

  void _onSelectGiant() {
    setState(() {
      selectionMode = SelectionMode.giant;
    });
  }

  _warningsDialog(BuildContext context) {
    var tableRows = <TableRow>[];

    const double fontSize = 20.0;

    for (Warning warning in _warnings) {
      var tableCells = <TableCell>[];

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText(warning.leftOperand.toString(),
                  maxLines: 1,
                  group: groupWarning,
                  style: TextStyle(fontSize: fontSize)))));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.center,
              child: AutoSizeText(square,
                  maxLines: 1,
                  group: groupWarning,
                  style: TextStyle(
                      color: getColorForLandType(warning.landType))))));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.center,
              child: AutoSizeText(crown * warning.crown,
                  maxLines: 1,
                  group: groupWarning,
                  style: TextStyle(fontSize: fontSize)))));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.center,
              child: AutoSizeText(warning.operator,
                  maxLines: 1,
                  group: groupWarning,
                  style: TextStyle(fontSize: fontSize)))));

      tableCells.add(TableCell(
          child: Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText(warning.rightOperand.toString(),
                  maxLines: 1,
                  group: groupWarning,
                  style: TextStyle(fontSize: fontSize)))));

      TableRow tableRow = TableRow(children: tableCells);
      tableRows.add(tableRow);
    }

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(1.5),
          backgroundColor: Colors.white60,
          content: SingleChildScrollView(child: Table(children: tableRows)),
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
          backgroundColor: Colors.white60,
          title: Text('Kingdomino Score',
              style: TextStyle(
                  color: Colors.amber,
                  fontSize: 35.0,
                  fontFamily: 'Augusta',
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 3.0,
                      color: Color.fromARGB(255, 255, 255, 255),
                    )
                  ])),
          content: const Text('Olivier Drevet - GPL v.3',
              style: TextStyle(fontSize: 15.0)),
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
    const double fontSize = 20.0;

    var properties = kingdom.getProperties();

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
          child: AutoSizeText('${property.landCount}',
              maxLines: 1,
              group: groupScore,
              style: TextStyle(fontSize: fontSize)),
        )));
        tableCells.add(TableCell(
            child: Align(
          alignment: Alignment.centerRight,
          child: AutoSizeText(square,
              maxLines: 1,
              group: groupScore,
              style: TextStyle(color: getColorForLandType(property.landType))),
        )));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText('x',
                    maxLines: 1,
                    group: groupScore,
                    style: TextStyle(fontSize: fontSize)))));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText(property.crownCount.toString(),
                    maxLines: 1,
                    group: groupScore,
                    style: TextStyle(fontSize: fontSize)))));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText(crown,
                    maxLines: 1,
                    group: groupScore,
                    style: TextStyle(fontSize: fontSize)))));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.center,
                child: AutoSizeText('=',
                    maxLines: 1,
                    group: groupScore,
                    style: TextStyle(fontSize: fontSize)))));
        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText(
                    '${property.landCount * property.crownCount}',
                    maxLines: 1,
                    group: groupScore,
                    style: TextStyle(fontSize: fontSize)))));

        var tableRow = TableRow(children: tableCells);
        tableRows.add(tableRow);
      }

      //quests points
      if (quests.isNotEmpty) {
        var tableCells = <TableCell>[];

        tableCells.add(TableCell(child: AutoSizeText('')));
        tableCells.add(TableCell(child: AutoSizeText('')));
        tableCells.add(TableCell(child: AutoSizeText('')));
        tableCells.add(TableCell(child: AutoSizeText('')));

        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText(shield,
                    maxLines: 1,
                    group: groupScore,
                    style: TextStyle(fontSize: fontSize)))));

        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.center,
                child: AutoSizeText('=',
                    maxLines: 1,
                    group: groupScore,
                    style: TextStyle(fontSize: fontSize)))));

        tableCells.add(TableCell(
            child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText(_scoreQuest.toString(),
                    maxLines: 1,
                    group: groupScore,
                    style: TextStyle(fontSize: fontSize)))));

        var tableRow = TableRow(children: tableCells);
        tableRows.add(tableRow);
      }

      content = SingleChildScrollView(child: Table(children: tableRows));
    }

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(1.5),
          backgroundColor: Colors.white60,
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

      var count = kingdom
          .getLands()
          .expand((i) => i)
          .toList()
          .where((land) => land.landType == landType)
          .length;
      if (count > getGameSet()[landType]['count']) {
        Warning warning =
            Warning(count, landType, 0, '>', getGameSet()[landType]['count']);

        setState(() {
          _warnings.add(warning);
        });
      }

      //check for too many tile with given crowns
      for (var crownsCounter = 1;
          crownsCounter <= getGameSet()[landType]['crowns']['max'];
          crownsCounter++) {
        var count = kingdom
            .getLands()
            .expand((i) => i)
            .toList()
            .where((land) =>
                land.landType == landType && land.crowns == crownsCounter)
            .length;

        if (count > getGameSet()[landType]['crowns'][crownsCounter]) {
          Warning warning = Warning(count, landType, crownsCounter, '>',
              getGameSet()[landType]['crowns'][crownsCounter]);

          setState(() {
            _warnings.add(warning);
          });
        }
      }
    }
  }

  void updateScoreQuest() {
    var scoreQuest = 0;

    for (var i = 0; i < quests.length; i++) {
      scoreQuest += quests[i].getPoints(kingdom);
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
    var properties = kingdom.getProperties();
    setState(() {
      _scoreProperty = kingdom.calculateScoreFromProperties(properties);
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

  Widget landButton(LandType landType) {
    var isSelected = (selectionMode == SelectionMode.land ||
            selectionMode == SelectionMode.castle) &&
        selectedLandType == landType;

    var outline = Border(
      right: BorderSide(width: 3.5, color: Colors.blueGrey.shade600),
      bottom: BorderSide(width: 3.5, color: Colors.blueGrey.shade900),
    );

    return GestureDetector(
        onTap: () => _onSelectLandType(landType),
        child: Container(
          margin: EdgeInsets.all(5.0),
          height: 50.0,
          width: 50.0,
          decoration: BoxDecoration(
              border: isSelected
                  ? Border(
                      right: BorderSide(width: 3.5, color: Colors.red.shade600),
                      top: BorderSide(width: 3.5, color: Colors.red.shade600),
                      left: BorderSide(width: 3.5, color: Colors.red.shade600),
                      bottom:
                          BorderSide(width: 3.5, color: Colors.red.shade900),
                    )
                  : landType == LandType.none ? null : outline),
          child: Container(
              color: getColorForLandType(landType),
              child: landType == LandType.castle
                  ? FittedBox(fit: BoxFit.fitHeight, child: Text(castle))
                  : Text('')),
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

  Container giantButton() {
    return Container(
        margin: EdgeInsets.all(margin),
        child: OutlineButton(
            borderSide:
                selectionMode == SelectionMode.giant ? selectedBorder : null,
            onPressed: () => _onSelectGiant(),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Text(giant, style: TextStyle(fontSize: 30.0))));
  }

  @override
  Widget build(BuildContext context) {
    var kingdomEditorWidgets = [
      landButton(LandType.wheat),
      landButton(LandType.grassland),
      landButton(LandType.forest),
      landButton(LandType.lake),
      landButton(LandType.swamp),
      landButton(LandType.mine),
      landButton(LandType.none),
      landButton(LandType.castle),
      crownButton(),
    ];

    if (aog) kingdomEditorWidgets.add(giantButton());

    var kingdomEditor = Wrap(
      children: kingdomEditorWidgets,
    );

    var actions = <Widget>[
      MaterialButton(
          minWidth: 30,
          onPressed: () {
            setState(() {
              aog = !aog;

              quests.clear();

              kingdom.getLands().expand((i) => i).toList().forEach((land) {
                land.hasGiant = false;
              });

              clearWarnings();
              checkKingdom();

              updateScores();

              if (selectionMode == SelectionMode.giant) {
                selectionMode = SelectionMode.crown;
              }
            });
          },
          child: Container(
              child: Text('AG',
                  style: TextStyle(
                      fontSize: 25.0,
                      fontFamily: 'Augusta',
                      color: aog ? Colors.red : Colors.white)))),
      QuestDialogWidget(this),
      IconButton(
          icon: Icon(kingdom.size == 5 ? Icons.filter_5 : Icons.filter_7),
          onPressed: () {
            setState(() {
              if (kingdom.size == 5)
                kingdom.reSize(7);
              else
                kingdom.reSize(5);

              resetScores();
              clearWarnings();
              _onSelectCastle();
            });
          }),
      IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            setState(() {
              kingdom.clear();
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
                child: Container(
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: Text(
                    '${_warnings.length}',
                    style: TextStyle(
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
            child: kingdomEditor, color: Theme.of(context).primaryColor),
        body: Column(children: <Widget>[
          KingdomWidget(this),
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
