import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/cubits/kingdom_cubit.dart';
import 'package:kingdomino_score_count/cubits/app_state_cubit.dart';
import 'package:kingdomino_score_count/cubits/theme_cubit.dart';
import 'package:kingdomino_score_count/widgets/kingdomino_app_bar.dart';
import 'package:kingdomino_score_count/widgets/score/score_widget.dart';
import 'package:kingdomino_score_count/widgets/warning_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../models/check_kingdom.dart';
import '../models/extensions/extension.dart';
import '../models/game_set.dart';
import '../models/kingdom.dart';
import '../models/user_selection.dart';
import '../models/warning.dart';
import 'tile/tile_bar.dart';
import 'kingdom_widget.dart';

const String crown = '\u{1F451}';
const String castle = '\u{1F3F0}';
const String square = '\u{25A0}';

class KingdominoWidget extends StatefulWidget {
  const KingdominoWidget({
    super.key,
  });

  @override
  State<KingdominoWidget> createState() => _KingdominoWidgetState();
}

class _KingdominoWidgetState extends State<KingdominoWidget> {
  List<Warning> warnings = [];
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );
  String dropdownSelectedExtension = '';

  _KingdominoWidgetState();

  setKingColor(MaterialColor materialColor) =>
      context.read<ThemeCubit>().updateTheme(materialColor);

  @override
  initState() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      _packageInfo = packageInfo;
    });

    super.initState();
  }

  void calculateScore(Kingdom kingdom) {
    clearWarnings();
    setState(() {
      warnings = checkKingdom(kingdom, context.read<AppStateCubit>().state.userSelection.extension);
    });
    context.read<AppStateCubit>().calculateScore(kingdom);
  }

  void clearWarnings() {
    setState(() {
      warnings.clear();
    });
  }

  void onKingdomClear() => setState(() {
        clearWarnings();
        context.read<AppStateCubit>().reset();
      });

  void onExtensionSelect(Kingdom kingdom, String? newValue) => setState(() {
        dropdownSelectedExtension = newValue!;

        kingdom.getLands().expand((i) => i).toList().forEach((land) {
          land.hasResource = false;
          land.courtier = null;
        });

        kingdom.getLands().expand((i) => i).toList().forEach((land) {
          land.giants = 0;
        });

        switch (newValue) {
          case '':
            context.read<AppStateCubit>().state.userSelection.extension = null;
            context.read<AppStateCubit>().state.userSelection.setSelectionMode(SelectionMode.land);
            context.read<AppStateCubit>().state.userSelection.setSelectedLandType(null);

            kingColors.remove(Colors.brown.shade800);
            if (context.read<ThemeCubit>().state == Colors.brown.shade800) {
              setKingColor(kingColors.first);
            }
            break;
          case 'Giants':
            context.read<AppStateCubit>().state.userSelection.extension = Extension.ageOfGiants;
            context.read<AppStateCubit>().state.userSelection.setSelectionMode(SelectionMode.land);
            context.read<AppStateCubit>().state.userSelection.setSelectedLandType(null);

            kingColors.add(Colors.brown);
            break;
          case 'LaCour':
            context.read<AppStateCubit>().state.userSelection.extension = Extension.laCour;

            context.read<AppStateCubit>().state.userSelection.setSelectionMode(SelectionMode.land);
            context.read<AppStateCubit>().state.userSelection.setSelectedLandType(null);

            if (context.read<AppStateCubit>().state.userSelection.getSelectionMode() == SelectionMode.courtier ||
                context.read<AppStateCubit>().state.userSelection.getSelectionMode() == SelectionMode.resource) {
              context.read<AppStateCubit>().state.userSelection.setSelectionMode(SelectionMode.crown);
            }
            kingColors.remove(Colors.brown.shade800);
            if (context.read<ThemeCubit>().state == Colors.brown.shade800) {
              setKingColor(kingColors.first);
            }
            break;
        }

        context.read<KingdomCubit>().clearHistory();
        context
            .read<AppStateCubit>()
            .state
            .userSelection
            .selectedQuests
            .clear();
        clearWarnings();
        setState(() {
          warnings = checkKingdom(kingdom, context.read<AppStateCubit>().state.userSelection.extension);
        });

        calculateScore(context.read<KingdomCubit>().state);
      });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KingdomCubit, Kingdom>(
      builder: (BuildContext context, kingdom) {
        Widget body = OrientationBuilder(
            builder: (orientationBuilderContext, orientation) {
          if (orientation == Orientation.portrait) {
            return Column(children: <Widget>[
              // ignore: prefer_const_constructors
              Expanded(
                flex: 4,
                // ignore: prefer_const_constructors
                child: ScoreWidget(),
              ),
              Expanded(
                flex: 5,
                child: KingdomWidget(
                    calculateScore: calculateScore,
                    kingdom: kingdom),
              ),
              const TileBar(
                verticalAlign: false,
              ),
            ]);
          } else {
            return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const Expanded(child: ScoreWidget(),
                  ),
                  KingdomWidget(
                      calculateScore: calculateScore,
                      kingdom: kingdom),
                  const TileBar(
                    verticalAlign: true,
                  )
                ]);
          }
        });

        return Scaffold(
            appBar: KingdominoAppBar(
              onExtensionSelect: onExtensionSelect,
              dropdownSelectedExtension: dropdownSelectedExtension,
              onKingdomClear: onKingdomClear,
              packageInfo: _packageInfo,
              calculateScore: calculateScore,
            ),
            floatingActionButton: warnings.isEmpty
                ? null
                : FloatingActionButton(
                    child: Badge(
                        label: Text(warnings.length.toString()),
                        child: const Icon(Icons.warning)),
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: WarningsWidget(warnings: warnings),
                            actions: <Widget>[
                              TextButton(
                                child: const Icon(
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
                      );
                    }),
            body: body);
      },
    );
  }
}
