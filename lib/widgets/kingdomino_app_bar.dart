import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/cubits/game_cubit.dart';
import 'package:kingdomino_score_count/cubits/kingdom_cubit.dart';
import 'package:kingdomino_score_count/widgets/quest_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../models/extensions/age_of_giants.dart';
import '../models/extensions/extension.dart';
import '../models/game_set.dart';
import '../models/kingdom.dart';
import '../models/kingdom_size.dart';

class KingdominoAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String dropdownSelectedExtension;
  final void Function(Kingdom, String?) onExtensionSelect;
  final void Function(Kingdom) refreshWarnings;
  final Function onKingdomClear;
  final PackageInfo packageInfo;

  const KingdominoAppBar({
    this.preferredSize = const Size.fromHeight(50.0),
    required this.onExtensionSelect,
    required this.dropdownSelectedExtension,
    required this.packageInfo,
    required this.onKingdomClear,
    required this.refreshWarnings,
    super.key,
  });

  @override
  State<KingdominoAppBar> createState() => _KingdominoAppBarState();
}

class _KingdominoAppBarState extends State<KingdominoAppBar> {
  @override
  Widget build(BuildContext context) {
    var kingdom = context.read<KingdomCubit>().state;
    bool hasBrownKing =
        context.read<GameCubit>().state.extension == Extension.ageOfGiants;

    KingColor currentPlayer = context.read<GameCubit>().state.kingColor!;

    if (currentPlayer == KingColor.brown && !hasBrownKing) {
      context.read<GameCubit>().setPlayer(KingColor.blue);
      currentPlayer = KingColor.blue;
    }

    var actions = <Widget>[
      DropdownButton<KingColor>(
        value: currentPlayer,
        iconSize: 25,
        iconEnabledColor: Colors.white,
        underline: Container(height: 1, color: Colors.white),
        onChanged: (player) => context.read<GameCubit>().setPlayer(player!),
        items: KingColor.values
            .where((player) => player != KingColor.brown || hasBrownKing)
            .map<DropdownMenuItem<KingColor>>((KingColor player) {
          return DropdownMenuItem<KingColor>(
            value: player,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                player.color,
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
                  widget.refreshWarnings(context.read<KingdomCubit>().state);
                }
              : null,
          icon: const Icon(Icons.undo)),
      IconButton(
          onPressed: context.read<KingdomCubit>().canRedo
              ? () {
                  context.read<KingdomCubit>().redo();
                  widget.refreshWarnings(context.read<KingdomCubit>().state);
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
      QuestDialogWidget(widget.refreshWarnings),
      IconButton(
          icon: Icon(kingdom.kingdomSize == KingdomSize.small
              ? Icons.filter_5
              : Icons.filter_7),
          onPressed: () {
            context.read<KingdomCubit>().resize(
                kingdom.kingdomSize == KingdomSize.small
                    ? KingdomSize.large
                    : KingdomSize.small);
            widget.refreshWarnings(context.read<KingdomCubit>().state);
          }),
      IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            context.read<KingdomCubit>().clear();
            widget.onKingdomClear();
            widget.refreshWarnings(context.read<KingdomCubit>().state);
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
