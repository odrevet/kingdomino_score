import 'dart:collection';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:kingdomino_score_count/models/lacour/axe_warrior.dart';
import 'package:kingdomino_score_count/models/lacour/banker.dart';
import 'package:kingdomino_score_count/models/lacour/captain.dart';
import 'package:kingdomino_score_count/models/lacour/farmer.dart';
import 'package:kingdomino_score_count/models/lacour/fisherman.dart';
import 'package:kingdomino_score_count/models/lacour/heavy_archery.dart';
import 'package:kingdomino_score_count/models/lacour/king.dart';
import 'package:kingdomino_score_count/models/lacour/lacour.dart';
import 'package:kingdomino_score_count/models/lacour/light_archery.dart';
import 'package:kingdomino_score_count/models/lacour/lumberjack.dart';
import 'package:kingdomino_score_count/models/lacour/queen.dart';
import 'package:kingdomino_score_count/models/lacour/shepherdess.dart';
import 'package:kingdomino_score_count/models/lacour/sword_warrior.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../models/age_of_giants.dart';
import '../models/king_colors.dart';
import '../models/kingdom.dart';
import '../models/land.dart' show LandType;
import '../models/quests/quest.dart';
import '../models/warning.dart';
import '../score_quest.dart';
import 'bottom_bar.dart';
import 'kingdom_widget.dart';
import 'quest_dialog.dart';
import 'score_details_widget.dart';
import 'warning_widget.dart';

const String crown = '\u{1F451}';
const String castle = '\u{1F3F0}';
final String square = '\u{25A0}';

enum SelectionMode { land, crown, castle, giant, courtier, resource }

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

  KingdominoScoreWidget(
    this.setColor, {
    Key? key,
  }) : super(key: key);

  @override
  KingdominoScoreWidgetState createState() =>
      KingdominoScoreWidgetState(this.setColor);
}

class KingdominoScoreWidgetState extends State<KingdominoScoreWidget> {
  LandType? selectedLandType;
  CourtierType? selectedCourtierType;
  SelectionMode selectionMode = SelectionMode.land;
  var groupScore = AutoSizeGroup();
  var kingdom = Kingdom(5);
  int scoreProperty = 0;
  int scoreOfQuest = 0;
  int scoreOfLacour = 0;
  int score = 0;
  Color kingColor = kingColors.first;
  bool aog = false; // Age of Giants extension
  bool lacour = false;
  HashSet<QuestType> selectedQuests = HashSet();
  List<Warning> warnings = [];
  late PackageInfo _packageInfo;
  final Function setColor;

  KingdominoScoreWidgetState(this.setColor);

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

  bool getLacour() => lacour;

  LandType? getSelectedLandType() => selectedLandType;

  setSelectedLandType(LandType? landtype) {
    setState(() {
      this.selectedLandType = landtype;
    });
  }

  CourtierType? getSelectedCourtierType() => selectedCourtierType;

  setSelectedCourtierType(CourtierType courtiertype) {
    setState(() {
      this.selectedCourtierType = courtiertype;
    });
  }

  setSelectionMode(SelectionMode selectionMode) {
    setState(() {
      this.selectionMode = selectionMode;
    });
  }

  SelectionMode getSelectionMode() => selectionMode;

  Color getKingColor() => kingColor;

  setKingColor(Color color) {
    this.setColor(color); // set App color to king color
    setState(() {
      this.kingColor = color;
    });
  }

  void calculateScore() {
    clearWarnings();
    checkKingdom();
    updateScores();
  }

  Map<LandType, Map<String, dynamic>> getGameSet() {
    if (aog == true) {
      return gameAogSet;
    } else if (lacour == true) {
      return laCourGameSet;
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

  int calculateLacourScore() {
    int scoreOfLacour = 0;
    for (int y = 0; y < kingdom.size; y++) {
      for (int x = 0; x < kingdom.size; x++) {
        CourtierType? courtierType = kingdom.getLand(x, y)?.courtierType;
        if (courtierType != null) {
          switch (courtierType) {
            case CourtierType.farmer:
              scoreOfLacour += Farmer().getPoints(kingdom, x, y);
              break;
            case CourtierType.banker:
              scoreOfLacour += Banker().getPoints(kingdom, x, y);
              break;
            case CourtierType.lumberjack:
              scoreOfLacour += Lumberjack().getPoints(kingdom, x, y);
              break;
            case CourtierType.light_archery:
              scoreOfLacour += LightArchery().getPoints(kingdom, x, y);
              break;
            case CourtierType.fisherman:
              scoreOfLacour += Fisherman().getPoints(kingdom, x, y);
              break;
            case CourtierType.heavy_archery:
              scoreOfLacour += HeavyArchery().getPoints(kingdom, x, y);
              break;
            case CourtierType.shepherdess:
              scoreOfLacour += Shepherdess().getPoints(kingdom, x, y);
              break;
            case CourtierType.captain:
              scoreOfLacour += Captain().getPoints(kingdom, x, y);
              break;
            case CourtierType.axe_warrior:
              scoreOfLacour += AxeWarrior().getPoints(kingdom, x, y);
              break;
            case CourtierType.sword_warrior:
              scoreOfLacour += SwordWarrior().getPoints(kingdom, x, y);
              break;
            case CourtierType.king:
              scoreOfLacour += King().getPoints(kingdom, x, y);
              break;
            case CourtierType.queen:
              scoreOfLacour += Queen().getPoints(kingdom, x, y);
              break;
          }
        }
      }
    }

    return scoreOfLacour;
  }

  void updateScoreLacour() {
    setState(() {
      scoreOfLacour = calculateLacourScore();
    });
  }

  void updateScores() {
    updateScoreProperty();
    updateScoreQuest();
    if (this.lacour) {
      updateScoreLacour();
    }
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
      if (this.lacour) {
        score += scoreOfLacour;
      }
    });
  }

  void resetScores() {
    setState(() {
      score = scoreProperty = scoreOfQuest = scoreOfLacour = 0;
    });
  }

  String dropdownSelectedExtension = '';

  @override
  Widget build(BuildContext context) {
    var actions = <Widget>[
      !kIsWeb
          ?
          // King Color selector
          DropdownButton<Color>(
              value: kingColor,
              iconSize: 25,
              iconEnabledColor: Colors.white,
              underline: Container(height: 1, color: Colors.white),
              onChanged: (Color? newValue) {
                setState(() {
                  kingColor = newValue!;
                });
                setKingColor(kingColor);
              },
              items: kingColors.map<DropdownMenuItem<Color>>((Color value) {
                return DropdownMenuItem<Color>(
                  value: value,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(value, BlendMode.hue),
                    child: Image.asset(
                      'assets/king_pawn.png',
                      height: 25,
                      width: 25,
                    ),
                  ),
                );
              }).toList(),
            )
          : Text(''),
      Text(' '),
      // Extension Selector
      DropdownButton<String>(
        value: dropdownSelectedExtension,
        icon: const Icon(Icons.extension),
        iconSize: 25,
        elevation: 16,
        underline: Container(height: 1, color: Colors.white),
        onChanged: (String? newValue) {
          setState(() {
            dropdownSelectedExtension = newValue!;

            kingdom.getLands().expand((i) => i).toList().forEach((land) {
              land.hasResource = false;
              land.courtierType = null;
            });

            kingdom.getLands().expand((i) => i).toList().forEach((land) {
              land.giants = 0;
            });

            switch (newValue) {
              case '':
                aog = false;
                lacour = false;
                kingColors.remove(Colors.brown.shade800);
                if (kingColor == Colors.brown.shade800) {
                  setKingColor(kingColors.first);
                }
                break;
              case 'Giants':
                aog = true;
                lacour = false;
                if (selectionMode == SelectionMode.giant) {
                  selectionMode = SelectionMode.crown;
                }

                kingColors.add(Colors.brown);
                break;
              case 'LaCour':
                lacour = true;
                aog = false;
                if (selectionMode == SelectionMode.courtier ||
                    selectionMode == SelectionMode.resource) {
                  selectionMode = SelectionMode.crown;
                }
                kingColors.remove(Colors.brown.shade800);
                if (kingColor == Colors.brown.shade800) {
                  setKingColor(kingColors.first);
                }
                break;
            }

            selectedQuests.clear();
            clearWarnings();
            checkKingdom();
            updateScores();
          });
        },
        items: <String>['', 'Giants', 'LaCour']
            .map<DropdownMenuItem<String>>((String value) {
          Widget child;

          if (value == 'Giants') {
            child = Text(giant);
          } else if (value == 'LaCour') {
            child = Image.asset(
              'assets/lacour/resource.png',
              height: 25,
              width: 25,
            );
          } else {
            child = Text('');
          }
          return DropdownMenuItem<String>(
            value: value,
            child: child,
          );
        }).toList(),
      ),
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
          onPressed: () => showAboutDialog(
              context: context,
              applicationName: 'Kingdomino Score',
              applicationVersion: kIsWeb ? 'Web Build' : _packageInfo.version,
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
          Badge(
            position: BadgePosition.topEnd(top: 1, end: 5),
            badgeContent: Text(warnings.length.toString()),
            child: IconButton(
                icon: Icon(Icons.warning),
                onPressed: () => showDialog<void>(
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
          ));
    }

    Widget body = OrientationBuilder(builder: (context, orientation) {
      if (orientation == Orientation.portrait) {
        return Column(children: <Widget>[
          KingdomWidget(
              getSelectionMode: this.getSelectionMode,
              getSelectedLandType: this.getSelectedLandType,
              getSelectedCourtierType: this.getSelectedCourtierType,
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
                    onTap: () => showDialog<void>(
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
                                  scoreOfQuest: this.scoreOfQuest,
                                  scoreOfLacour: this.scoreOfLacour,
                                  getLacour: this.getLacour),
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
                  scoreOfQuest: this.scoreOfQuest,
                  scoreOfLacour: this.scoreOfLacour,
                  getLacour: this.getLacour)),
          KingdomWidget(
              getSelectionMode: this.getSelectionMode,
              getSelectedLandType: this.getSelectedLandType,
              getSelectedCourtierType: this.getSelectedCourtierType,
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
              getSelectedCourtierType: getSelectedCourtierType,
              setSelectedCourtierType: setSelectedCourtierType,
              getAog: getAog,
              getLacour: getLacour,
              kingdom: kingdom,
              scoreOfQuest: this.scoreOfQuest,
              quests: this.selectedQuests,
              groupScore: this.groupScore,
              score: this.score,
              setKingColor: this.setKingColor,
              getKingColor: this.getKingColor,
            ),
            color: Theme.of(context).primaryColor),
        body: body);
  }
}
