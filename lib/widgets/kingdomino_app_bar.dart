import 'package:badges/badges.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/kingdom_cubit.dart';
import 'package:kingdomino_score_count/models/land.dart';
import 'package:kingdomino_score_count/widgets/quest_dialog.dart';
import 'package:kingdomino_score_count/widgets/warning_widget.dart';

import '../models/age_of_giants.dart';
import '../models/king_colors.dart';

class KingdominoAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final kingdom;
  final kingColor;
  final getAog;
  final String dropdownSelectedExtension;
  final void Function(String?)? onExtensionSelect;
  final void Function(Color?)? onSelectKingColor;
  final warnings;
  final packageInfo;
  final getSelectedQuests;
  final updateScores;
  final onKingdomClear;

  const KingdominoAppBar({
    this.preferredSize = const Size.fromHeight(50.0),
    required this.kingdom,
    required this.kingColor,
    required this.onExtensionSelect,
    required this.getAog,
    required this.dropdownSelectedExtension,
    required this.onSelectKingColor,
    required this.warnings,
    required this.packageInfo,
    required this.getSelectedQuests,
    required this.updateScores,
    required this.onKingdomClear,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var actions = <Widget>[
      IconButton(
          onPressed: context.read<KingdomCubit>().canUndo
              ? context.read<KingdomCubit>().undo
              : null,
          icon: const Icon(Icons.undo)),
      IconButton(
          onPressed: context.read<KingdomCubit>().canRedo
              ? context.read<KingdomCubit>().redo
              : null,
          icon: const Icon(Icons.redo)),
      VerticalDivider(),
      !kIsWeb
          ?
          // King Color selector
          DropdownButton<Color>(
              value: kingColor,
              iconSize: 25,
              iconEnabledColor: Colors.white,
              underline: Container(height: 1, color: Colors.white),
              onChanged: onSelectKingColor,
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
      VerticalDivider(),
      // Extension Selector
      DropdownButton<String>(
        value: dropdownSelectedExtension,
        icon: const Icon(Icons.extension),
        iconSize: 25,
        elevation: 16,
        underline: Container(height: 1, color: Colors.white),
        onChanged: onExtensionSelect,
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
          onPressed: () =>
              context.read<KingdomCubit>().resize(kingdom.size == 5 ? 7 : 5)),
      VerticalDivider(),
      IconButton(icon: Icon(Icons.delete), onPressed: onKingdomClear),
      VerticalDivider(),
      IconButton(
          icon: Icon(Icons.help),
          onPressed: () => showAboutDialog(
              context: context,
              applicationName: 'Kingdomino Score',
              applicationVersion: kIsWeb ? 'Web Build' : packageInfo.version,
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

    return AppBar(
      title: Row(mainAxisAlignment: MainAxisAlignment.end, children: actions),
    );
  }
}
