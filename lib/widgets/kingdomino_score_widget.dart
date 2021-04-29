import 'dart:collection';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import '../models/age_of_giants.dart';
import '../models/kingdom.dart';
import '../models/quest.dart';
import '../models/warning.dart';
import '../models/land.dart' show LandType;
import '../scoreQuest.dart';
import 'warning_widget.dart';
import 'kingdom_widget.dart';
import 'bottom_bar.dart';
import 'quest_dialog.dart';
import 'score_details_widget.dart';
import 'camera.dart';

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

class KingdominoScoreWidget extends StatefulWidget {
  final Function setColor;
  final camera;

  KingdominoScoreWidget(this.setColor,
      this.camera, {
        Key? key,
      }) : super(key: key);

  @override
  KingdominoScoreWidgetState createState() =>
      KingdominoScoreWidgetState(this.setColor, this.camera);
}

class KingdominoScoreWidgetState extends State<KingdominoScoreWidget> {
  LandType selectedLandType = LandType.none;
  SelectionMode selectionMode = SelectionMode.land;
  var groupScore = AutoSizeGroup();
  var kingdom = Kingdom(5);
  int scoreProperty = 0;
  int scoreOfQuest = 0;
  int score = 0;
  Color? kingColor;
  bool aog = false; // Age of Giants extension
  HashSet<QuestType> selectedQuests = HashSet();
  List<Warning> warnings = [];
  late PackageInfo _packageInfo;
  final Function setColor;
  bool cameraMode = false;
  final camera;

  KingdominoScoreWidgetState(this.setColor, this.camera);

  @override
  initState() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        _packageInfo = packageInfo;
      });
    });

    super.initState();
  }

  HashSet<QuestType> getSelectedQuests() => selectedQuests;

  bool getAog() => aog;

  LandType getSelectedLandType() => selectedLandType;

  setSelectedLandType(LandType landtype) {
    setState(() {
      this.selectedLandType = landtype;
    });
  }

  setSelectionMode(SelectionMode selectionMode) {
    setState(() {
      this.selectionMode = selectionMode;
    });
  }

  SelectionMode getSelectionMode() => selectionMode;

  Color? getKingColor() => kingColor;

  setKingColor(Color? color) {
    this.setColor(color); // set App color to king color

    if (color == null) {
      color = Colors.white;
    }
    setState(() {
      this.kingColor = color!;
    });
  }

  void calculateScore() {
    clearWarnings();
    checkKingdom();
    updateScores();
  }

  Map<LandType, Map<String, dynamic>> getGameSet() {
    if (aog == false) {
      return gameSet;
    } else {
      return gameAogSet;
    }
  }

  void clearWarnings() {
    setState(() {
      warnings.clear();
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
      if (count > getGameSet()[landType]!['count']) {
        Warning warning =
        Warning(count, landType, 0, '>', getGameSet()[landType]!['count']);

        setState(() {
          warnings.add(warning);
        });
      }

      //check if too many tile with given crowns
      for (var crownsCounter = 1;
      crownsCounter <= getGameSet()[landType]!['crowns']['max'];
      crownsCounter++) {
        var count = kingdom
            .getLands()
            .expand((i) => i)
            .toList()
            .where((land) =>
        land.landType == landType && land.crowns == crownsCounter)
            .length;

        if (count > getGameSet()[landType]!['crowns'][crownsCounter]) {
          Warning warning = Warning(count, landType, crownsCounter, '>',
              getGameSet()[landType]!['crowns'][crownsCounter]);

          setState(() {
            warnings.add(warning);
          });
        }
      }
    }
  }

  void updateScoreQuest() {
    setState(() {
      scoreOfQuest = calculateQuestScore(selectedQuests, kingdom);
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
      scoreProperty = kingdom.calculateScoreFromProperties(properties);
    });
  }

  void updateScore() {
    setState(() {
      score = scoreProperty + scoreOfQuest;
    });
  }

  void resetScores() {
    setState(() {
      score = scoreProperty = scoreOfQuest = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    var actions = <Widget>[
      IconButton(
          icon: Icon(Icons.camera_alt),
          onPressed: () {
            setState(() {
              cameraMode = !cameraMode;
            });
          }),
      MaterialButton(
          minWidth: 30,
          onPressed: () {
            setState(() {
              aog = !aog;
              selectedQuests.clear();
              kingdom.getLands().expand((i) => i).toList().forEach((land) {
                land.giants = 0;
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
      QuestDialogWidget(this.getSelectedQuests, this.updateScores, this.getAog),
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
              //_onSelectCastle();
            });
          }),
      IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            setState(() {
              kingdom.clear();
              clearWarnings();
              resetScores();
              //_onSelectCastle();
            });
          }),
      IconButton(
          icon: Icon(Icons.help),
          onPressed: () =>
              showAboutDialog(
                  context: context,
                  applicationName: _packageInfo.appName,
                  applicationVersion: _packageInfo.version,
                  applicationLegalese:
                  '''Drevet Olivier built the Kingdomino Score app under the GPL license Version 3. 
This SERVICE is provided by Drevet Olivier at no cost and is intended for use as is.
This page is used to inform visitors regarding the policy with the collection, use, and disclosure of Personal Information if anyone decided to use my Service.
I will not use or share your information with anyone : Kingdomino Score works offline and does not send any information over a network. ''',
                  applicationIcon: Image.asset(
                      'android/app/src/main/res/mipmap-mdpi/ic_launcher.png')))
    ];

    if (warnings.isNotEmpty) {
      actions.insert(
          0,
          Stack(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.warning),
                  onPressed: () =>
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                            content: WarningsWidget(warnings: this.warnings),
                            actions: <Widget>[
                              TextButton(
                                child: Icon(
                                  Icons.done,
                                  color: Colors.black87,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      )),
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
                    '${warnings.length}',
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

    Widget body = OrientationBuilder(builder: (context, orientation) {
      if (orientation == Orientation.portrait) {
       return cameraMode == true ? TakePictureScreen(
          // Pass the appropriate camera to the TakePictureScreen widget.
            camera: camera,
            kingdom: kingdom,
            onTap: () =>
                setState(() {
                  cameraMode = false;
                })) :
        Column(children: <Widget>[KingdomWidget(
              getSelectionMode: this.getSelectionMode,
              getSelectedLandType: this.getSelectedLandType,
              getGameSet: this.getGameSet,
              calculateScore: this.calculateScore,
              kingdom: this.kingdom,
              getKingColor: this.getKingColor),
          Expanded(
            child: FittedBox(
                fit: BoxFit.fitHeight,
                child: InkWell(
                    child: Text(score.toString(),
                        style: TextStyle(color: Colors.white)),
                    onTap: () =>
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                              content: ScoreDetailsWidget(
                                  kingdom: this.kingdom,
                                  groupScore: this.groupScore,
                                  quests: this.selectedQuests,
                                  score: this.score,
                                  scoreOfQuest: this.scoreOfQuest),
                              actions: <Widget>[
                                TextButton(
                                  child: Icon(
                                    Icons.done,
                                    color: Colors.black87,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        ))),
          )
        ]);
      } else {
        return Row(children: <Widget>[
          Expanded(
              child: ScoreDetailsWidget(
                  kingdom: this.kingdom,
                  groupScore: this.groupScore,
                  quests: this.selectedQuests,
                  score: this.score,
                  scoreOfQuest: this.scoreOfQuest)),
          KingdomWidget(
              getSelectionMode: this.getSelectionMode,
              getSelectedLandType: this.getSelectedLandType,
              getGameSet: this.getGameSet,
              calculateScore: this.calculateScore,
              kingdom: this.kingdom,
              getKingColor: getKingColor),
          Expanded(
            child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(score.toString(),
                    style: TextStyle(color: Colors.white))),
          )
        ]);
      }
    });

    return Scaffold(
        appBar: AppBar(
          title:
          Row(mainAxisAlignment: MainAxisAlignment.end, children: actions),
        ),
        bottomNavigationBar: BottomAppBar(
            child: BottomBar(
              getSelectionMode: getSelectionMode,
              setSelectionMode: setSelectionMode,
              getSelectedLandType: getSelectedLandType,
              setSelectedLandType: setSelectedLandType,
              getAog: getAog,
              kingdom: kingdom,
              scoreOfQuest: this.scoreOfQuest,
              quests: this.selectedQuests,
              groupScore: this.groupScore,
              score: this.score,
              setKingColor: this.setKingColor,
              getKingColor: this.getKingColor,
            ),
            color: Theme
                .of(context)
                .primaryColor),
        body: body);
  }
}
