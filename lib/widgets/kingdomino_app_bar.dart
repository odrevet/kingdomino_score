import 'package:badges/badges.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/cubits/kingdom_cubit.dart';
import 'package:kingdomino_score_count/widgets/quest_dialog.dart';
import 'package:kingdomino_score_count/widgets/warning_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../cubits/score_cubit.dart';
import '../cubits/theme_cubit.dart';
import '../models/age_of_giants.dart';
import '../models/king_colors.dart';
import '../models/kingdom.dart';
import '../models/warning.dart';

class KingdominoAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final Function getExtension;
  final String dropdownSelectedExtension;
  final void Function(Kingdom, String?) onExtensionSelect;
  final void Function(Kingdom) calculateScore;
  final Function getSelectedQuests;
  final Function onKingdomClear;
  final List<Warning> warnings;
  final PackageInfo packageInfo;

  const KingdominoAppBar({
    this.preferredSize = const Size.fromHeight(50.0),
    required this.onExtensionSelect,
    required this.getExtension,
    required this.dropdownSelectedExtension,
    required this.warnings,
    required this.packageInfo,
    required this.getSelectedQuests,
    required this.onKingdomClear,
    required this.calculateScore,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var kingdom = context.read<KingdomCubit>().state;

    var actions = <Widget>[
      IconButton(
          onPressed: context.read<KingdomCubit>().canUndo
              ? () {
                  context.read<KingdomCubit>().undo();
                  calculateScore(context.read<KingdomCubit>().state);
                }
              : null,
          icon: const Icon(Icons.undo)),
      IconButton(
          onPressed: context.read<KingdomCubit>().canRedo
              ? () {
                  context.read<KingdomCubit>().redo();
                  calculateScore(context.read<KingdomCubit>().state);
                }
              : null,
          icon: const Icon(Icons.redo)),
      const VerticalDivider(),
      // Extension Selector
      DropdownButton<String>(
        value: dropdownSelectedExtension,
        icon: const Icon(Icons.extension, color: Colors.white),
        iconSize: 25,
        elevation: 16,
        underline: Container(height: 1, color: Colors.white),
        onChanged: (value) => onExtensionSelect(kingdom, value),
        items: <String>['', 'Giants', 'LaCour']
            .map<DropdownMenuItem<String>>((String value) {
          Widget child;

          if (value == 'Giants') {
            child = const Text(giant);
          } else if (value == 'LaCour') {
            child = Image.asset(
              'assets/lacour/resource.png',
              height: 25,
              width: 25,
            );
          } else {
            child = const Text('');
          }
          return DropdownMenuItem<String>(
            value: value,
            child: child,
          );
        }).toList(),
      ),
      QuestDialogWidget(getSelectedQuests, calculateScore, getExtension),
      IconButton(
          icon: Icon(kingdom.size == 5 ? Icons.filter_5 : Icons.filter_7),
          onPressed: () =>
              context.read<KingdomCubit>().resize(kingdom.size == 5 ? 7 : 5)),
      const VerticalDivider(),
      IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            context.read<KingdomCubit>().clear();
            onKingdomClear();
          }),
      const VerticalDivider(),
      IconButton(
          icon: const Icon(Icons.help),
          onPressed: () => showAboutDialog(
              context: context,
              applicationName: 'Kingdomino Score',
              applicationVersion: kIsWeb ? 'Web build ' : packageInfo.version,
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
                icon: const Icon(Icons.warning),
                onPressed: () => showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
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
                    )),
          ));
    }

    return AppBar(
        leading: DropdownButton<MaterialColor>(
          value: context.read<ThemeCubit>().state,
          iconSize: 25,
          iconEnabledColor: Colors.white,
          underline: Container(height: 1, color: Colors.white),
          onChanged: (materialColor) =>
              context.read<ThemeCubit>().updateTheme(materialColor!),
          items: kingColors
              .map<DropdownMenuItem<MaterialColor>>((MaterialColor value) {
            return DropdownMenuItem<MaterialColor>(
              value: value,
              child: Container(
                color: value,
                child: Image.asset(
                  'assets/king_pawn.png',
                  height: 25,
                  width: 25,
                ),
              ),
            );
          }).toList(),
        ),
        actions: actions,
        title: Text(context.read<ScoreCubit>().state.score.toString()));
  }
}
