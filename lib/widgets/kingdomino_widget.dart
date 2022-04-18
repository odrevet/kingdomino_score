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
import '../models/extension.dart';
import '../models/game_set.dart';
import '../models/king_colors.dart';
import '../models/kingdom.dart';
import '../models/land.dart' show LandType;
import '../models/quests/quest.dart';
import '../models/selection_mode.dart';
import '../models/warning.dart';
import 'bottom_bar.dart';
import 'kingdom_widget.dart';
import 'score_details_widget.dart';

const String crown = '\u{1F451}';
const String castle = '\u{1F3F0}';
const String square = '\u{25A0}';

class KingdominoWidget extends StatefulWidget {
  const KingdominoWidget({
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

  Extension? extension;

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

  Extension? getExtension() => extension;

  LandType? getSelectedLandType() => selectedLandType;

  setSelectedLandType(LandType? landtype) {
    setState(() {
      selectedLandType = landtype;
    });
  }

  CourtierType? getSelectedCourtierType() => selectedCourtierType;

  setSelectedCourtierType(CourtierType courtiertype) {
    setState(() {
      selectedCourtierType = courtiertype;
    });
  }

  setExtension(Extension extension) {
    setState(() {
      extension = extension;
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
    context.read<ScoreCubit>().calculate(kingdom, extension, selectedQuests);
  }

  Map<LandType, Map<String, dynamic>> getGameSet() {
    if (extension == Extension.ageOfGiants) {
      return gameAogSet;
    } else if (extension == Extension.laCour) {
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
            extension = null;
            setSelectionMode(SelectionMode.land);
            kingColors.remove(Colors.brown.shade800);
            if (context.read<ThemeCubit>().state == Colors.brown.shade800) {
              setKingColor(kingColors.first);
            }
            break;
          case 'Giants':
            setExtension(Extension.ageOfGiants);
            setSelectionMode(SelectionMode.land);

            kingColors.add(Colors.brown);
            break;
          case 'LaCour':
            setExtension(Extension.laCour);
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
        Widget body = OrientationBuilder(
            builder: (orientationBuilderContext, orientation) {
          if (orientation == Orientation.portrait) {
            return Column(children: <Widget>[
              KingdomWidget(
                  getSelectionMode: getSelectionMode,
                  getSelectedLandType: getSelectedLandType,
                  getSelectedCourtierType: getSelectedCourtierType,
                  getGameSet: getGameSet,
                  calculateScore: calculateScore,
                  kingdom: kingdom),
              Expanded(
                child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: InkWell(
                        child: Text(
                            context.read<ScoreCubit>().state.score.toString()),
                        onTap: () => showDialog<void>(
                              context: context,
                              builder: (BuildContext dialogContext) {
                                return AlertDialog(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0))),
                                  content: ScoreDetailsWidget(
                                      groupScore: groupScore,
                                      quests: selectedQuests,
                                      getExtension: getExtension),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Icon(Icons.done),
                                      onPressed: () {
                                        Navigator.of(dialogContext).pop();
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
                      groupScore: groupScore,
                      quests: selectedQuests,
                      getExtension: getExtension)),
              KingdomWidget(
                  getSelectionMode: getSelectionMode,
                  getSelectedLandType: getSelectedLandType,
                  getSelectedCourtierType: getSelectedCourtierType,
                  getGameSet: getGameSet,
                  calculateScore: calculateScore,
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
              getExtension: getExtension,
              dropdownSelectedExtension: dropdownSelectedExtension,
              warnings: warnings,
              onKingdomClear: onKingdomClear,
              getSelectedQuests: getSelectedQuests,
              packageInfo: _packageInfo,
              calculateScore: calculateScore,
            ),
            bottomNavigationBar: BottomAppBar(
                child: BottomBar(
                  getSelectionMode: getSelectionMode,
                  setSelectionMode: setSelectionMode,
                  getSelectedLandType: getSelectedLandType,
                  setSelectedLandType: setSelectedLandType,
                  getSelectedCourtierType: getSelectedCourtierType,
                  setSelectedCourtierType: setSelectedCourtierType,
                  getExtension: getExtension,
                  quests: selectedQuests,
                  groupScore: groupScore,
                ),
                color: Theme.of(context).primaryColor),
            body: body);
      },
    );
  }
}
