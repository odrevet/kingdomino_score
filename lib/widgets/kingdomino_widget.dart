import 'dart:collection';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/cubits/kingdom_cubit.dart';
import 'package:kingdomino_score_count/cubits/score_cubit.dart';
import 'package:kingdomino_score_count/cubits/theme_cubit.dart';
import 'package:kingdomino_score_count/models/lacour/lacour.dart';
import 'package:kingdomino_score_count/widgets/kingdomino_app_bar.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../models/age_of_giants.dart';
import '../models/game_set.dart';
import '../models/king_colors.dart';
import '../models/kingdom.dart';
import '../models/land.dart' show LandType;
import '../models/quests/quest.dart';
import '../models/warning.dart';
import 'bottom_bar.dart';
import 'kingdom_widget.dart';
import 'score_details_widget.dart';

const String crown = '\u{1F451}';
const String castle = '\u{1F3F0}';
final String square = '\u{25A0}';

enum SelectionMode { land, crown, castle, giant, courtier, resource }

class KingdominoWidget extends StatefulWidget {
  KingdominoWidget({
    Key? key,
  }) : super(key: key);

  @override
  KingdominoWidgetState createState() => KingdominoWidgetState();
}

class KingdominoWidgetState extends State<KingdominoWidget> {
  LandType? selectedLandType;
  CourtierType? selectedCourtierType;
  SelectionMode selectionMode = SelectionMode.land;
  var groupScore = AutoSizeGroup();

  bool aog = false; // Age of Giants extension
  bool lacour = false;
  HashSet<QuestType> selectedQuests = HashSet();
  List<Warning> warnings = [];
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );
  String dropdownSelectedExtension = '';

  KingdominoWidgetState();

  setKingColor(MaterialColor materialColor) =>
      context.read<ThemeCubit>().updateTheme(materialColor);

  @override
  initState() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      _packageInfo = packageInfo;
    });

    selectedLandType = LandType.castle;
    selectionMode = SelectionMode.castle;

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

  void calculateScore(Kingdom kingdom) {
    clearWarnings();
    checkKingdom(kingdom);
    context.read<ScoreCubit>().calculate(kingdom, lacour, selectedQuests);
  }

  Map<LandType, Map<String, dynamic>> getGameSet() {
    if (aog == true) {
      return gameAogSet;
    } else if (lacour == true) {
      return laCourGameSet;
    } else {
      return gameSet;
    }
  }

  void clearWarnings() {
    setState(() {
      warnings.clear();
    });
  }

  ///check if the kingdom is conform, if not set warnings
  void checkKingdom(Kingdom kingdom) {
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

  void onKingdomClear() => setState(() {
        clearWarnings();
        context.read<ScoreCubit>().reset();
      });

  void onExtensionSelect(Kingdom kingdom, String? newValue) => setState(() {
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
            setSelectionMode(SelectionMode.land);
            kingColors.remove(Colors.brown.shade800);
            if (context.read<ThemeCubit>().state == Colors.brown.shade800) {
              setKingColor(kingColors.first);
            }
            break;
          case 'Giants':
            aog = true;
            lacour = false;
            setSelectionMode(SelectionMode.land);

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
            if (context.read<ThemeCubit>().state == Colors.brown.shade800) {
              setKingColor(kingColors.first);
            }
            break;
        }

        context.read<KingdomCubit>().clearHistory();
        selectedQuests.clear();
        clearWarnings();
        checkKingdom(kingdom);
        //updateScores(kingdom);
      });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KingdomCubit, Kingdom>(
      builder: (BuildContext context, kingdom) {
        Widget body = OrientationBuilder(builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return Column(children: <Widget>[
              KingdomWidget(
                  getSelectionMode: this.getSelectionMode,
                  getSelectedLandType: this.getSelectedLandType,
                  getSelectedCourtierType: this.getSelectedCourtierType,
                  getGameSet: this.getGameSet,
                  calculateScore: this.calculateScore,
                  kingdom: kingdom),
              Expanded(
                child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: InkWell(
                        child: Text(
                            context.read<ScoreCubit>().state.score.toString()),
                        onTap: () => showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0))),
                                  content: ScoreDetailsWidget(
                                      groupScore: this.groupScore,
                                      quests: this.selectedQuests,
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
                      groupScore: this.groupScore,
                      quests: this.selectedQuests,
                      getLacour: this.getLacour)),
              KingdomWidget(
                  getSelectionMode: this.getSelectionMode,
                  getSelectedLandType: this.getSelectedLandType,
                  getSelectedCourtierType: this.getSelectedCourtierType,
                  getGameSet: this.getGameSet,
                  calculateScore: this.calculateScore,
                  kingdom: kingdom),
              Expanded(
                child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                        context.read<ScoreCubit>().state.score.toString())),
              )
            ]);
          }
        });

        return Scaffold(
            appBar: KingdominoAppBar(
              onExtensionSelect: onExtensionSelect,
              getAog: getAog,
              dropdownSelectedExtension: dropdownSelectedExtension,
              warnings: warnings,
              onKingdomClear: onKingdomClear,
              getSelectedQuests: getSelectedQuests,
              packageInfo: _packageInfo,
              calculateScore: this.calculateScore,
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
                  quests: this.selectedQuests,
                  groupScore: this.groupScore,
                ),
                color: Theme.of(context).primaryColor),
            body: body);
      },
    );
  }
}