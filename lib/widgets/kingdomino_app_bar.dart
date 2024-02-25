import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/cubits/kingdom_cubit.dart';
import 'package:kingdomino_score_count/widgets/quest_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../cubits/app_state_cubit.dart';
import '../cubits/theme_cubit.dart';
import '../models/extensions/age_of_giants.dart';
import '../models/king_colors.dart';
import '../models/kingdom.dart';

class KingdominoAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  final Function getExtension;
  final String dropdownSelectedExtension;
  final void Function(Kingdom, String?) onExtensionSelect;
  final void Function(Kingdom) calculateScore;
  final Function onKingdomClear;
  final PackageInfo packageInfo;

  const KingdominoAppBar({
    this.preferredSize = const Size.fromHeight(50.0),
    required this.onExtensionSelect,
    required this.getExtension,
    required this.dropdownSelectedExtension,
    required this.packageInfo,
    required this.onKingdomClear,
    required this.calculateScore,
    super.key,
  });

  @override
  State<KingdominoAppBar> createState() => _KingdominoAppBarState();
}

class _KingdominoAppBarState extends State<KingdominoAppBar> {
  @override
  Widget build(BuildContext context) {
    var kingdom = context.read<KingdomCubit>().state;

    var actions = <Widget>[
      DropdownButton<MaterialColor>(
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
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                value,
                BlendMode.srcATop,
              ),
              child: Image.asset(
                'assets/king_pawn.png',
                height: 25,
                width: 25,
              ),
            ),
          );
        }).toList(),
      ),
      IconButton(
          onPressed: context.read<KingdomCubit>().canUndo
              ? () {
                  context.read<KingdomCubit>().undo();
                  widget.calculateScore(context.read<KingdomCubit>().state);
                }
              : null,
          icon: const Icon(Icons.undo)),
      IconButton(
          onPressed: context.read<KingdomCubit>().canRedo
              ? () {
                  context.read<KingdomCubit>().redo();
                  widget.calculateScore(context.read<KingdomCubit>().state);
                }
              : null,
          icon: const Icon(Icons.redo)),
      // Extension Selector
      DropdownButton<String>(
        value: widget.dropdownSelectedExtension,
        icon: const Icon(Icons.extension, color: Colors.white),
        iconSize: 25,
        elevation: 16,
        underline: Container(height: 1, color: Colors.white),
        onChanged: (value) => widget.onExtensionSelect(kingdom, value),
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
      QuestDialogWidget(widget.calculateScore, widget.getExtension),
      IconButton(
          icon: Icon(kingdom.size == 5 ? Icons.filter_5 : Icons.filter_7),
          onPressed: () =>
              context.read<KingdomCubit>().resize(kingdom.size == 5 ? 7 : 5)),
      IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            context.read<KingdomCubit>().clear();
            widget.onKingdomClear();
          }),
      IconButton(
          icon: const Icon(Icons.help),
          onPressed: () => showAboutDialog(
              context: context,
              applicationName: 'Kingdomino Score',
              applicationVersion:
                  kIsWeb ? 'Web build ' : widget.packageInfo.version,
              applicationLegalese:
                  '''Drevet Olivier built the Kingdomino Score app under the GPL license Version 3. 
This SERVICE is provided by Drevet Olivier at no cost and is intended for use as is.
This page is used to inform visitors regarding the policy with the collection, use, and disclosure of Personal Information if anyone decided to use my Service.
I will not use or share your information with anyone : Kingdomino Score works offline and does not send any information over a network. ''',
              applicationIcon: Image.asset(
                  'android/app/src/main/res/mipmap-mdpi/ic_launcher.png')))
    ];

    return AppBar(actions: actions);
  }
}
