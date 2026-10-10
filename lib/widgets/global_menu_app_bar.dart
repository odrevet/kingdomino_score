import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/cubits/kingdom_cubit.dart';
import 'package:kingdomino_score_count/cubits/rules_cubit.dart';
import 'package:kingdomino_score_count/cubits/user_selection_cubit.dart';
import 'package:kingdomino_score_count/models/extensions/age_of_giants.dart';
import 'package:kingdomino_score_count/models/extensions/extension.dart';
import 'package:kingdomino_score_count/models/game_set.dart';
import 'package:kingdomino_score_count/models/kingdom_size.dart';
import 'package:kingdomino_score_count/models/rules.dart';
import 'package:kingdomino_score_count/models/user_selection.dart';
import 'package:kingdomino_score_count/widgets/about_dialog.dart';
import 'package:kingdomino_score_count/widgets/quest_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';

class GlobalMenuAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const GlobalMenuAppBar({
    this.preferredSize = const Size.fromHeight(50.0),
    super.key, required PackageInfo packageInfo,
  });

  @override
  State<GlobalMenuAppBar> createState() => _GlobalMenuAppBarState();
}

class _GlobalMenuAppBarState extends State<GlobalMenuAppBar> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RulesCubit, Rules>(
      builder: (context, rules) {
        final kingdomSize = rules.kingdomSize;

        var actions = <Widget>[
          // Extension Selector
          DropdownButton<Extension>(
            value: rules.extension,
            icon: const Icon(Icons.extension, color: Colors.white),
            iconSize: 25,
            elevation: 16,
            underline: const SizedBox.shrink(),
            onChanged: (value) {
              context.read<RulesCubit>().setExtension(value);
              context.read<UserSelectionCubit>().updateSelection(
                SelectionMode.land,
                null,
              );

              if (value == Extension.laCour &&
                  context
                      .read<UserSelectionCubit>()
                      .state
                      .getSelectionMode() ==
                      SelectionMode.courtier ||
                  context
                      .read<UserSelectionCubit>()
                      .state
                      .getSelectionMode() ==
                      SelectionMode.resource) {
                context
                    .read<UserSelectionCubit>()
                    .state
                    .setSelectionMode(SelectionMode.crown);
              }

              context.read<RulesCubit>().clearQuest();

              for (KingColor kingColor in KingColor.values) {
                KingdomCubit kingdomCubit = getKingdomCubit(
                  context,
                  kingColor,
                );
                kingdomCubit.clearExtension();
                kingdomCubit.clearHistory();
              }
            },
            items:
            <Extension>[
              Extension.vanilla,
              Extension.ageOfGiants,
              Extension.laCour,
              Extension.lostTreasures,
            ].map<DropdownMenuItem<Extension>>((Extension value) {
              Widget child;

              if (value == Extension.ageOfGiants) {
                child = const Text(giant);
              } else if (value == Extension.laCour) {
                child = Image.asset(
                  'assets/lacour/resource.png',
                  height: 25,
                  width: 25,
                );
              } else if (value == Extension.lostTreasures) {
                child = const Text('💎');
              } else {
                child = const Icon(
                  Icons.crop_square,
                  size: 25,
                  color: Colors.white,
                );
              }
              return DropdownMenuItem<Extension>(
                value: value,
                child: child,
              );
            }).toList(),
          ),
          QuestDialogWidget(),
          // Board size
          IconButton(
            icon: Icon(
              kingdomSize == KingdomSize.small
                  ? Icons.filter_5
                  : Icons.filter_7,
            ),
            onPressed: () {
              final newSize = kingdomSize == KingdomSize.small
                  ? KingdomSize.large
                  : KingdomSize.small;
              context.read<RulesCubit>().setKingdomSize(newSize);
              for (KingColor kingColor in KingColor.values) {
                getKingdomCubit(context, kingColor).resize(newSize);
              }
            },
          ),
          // Reset all boards
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              for (KingColor kingColor in KingColor.values) {
                getKingdomCubit(context, kingColor).clear();
              }
            },
          ),
          // About
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () => showKingdominoAboutDialog(context),
          ),
        ];
        return AppBar(
          titleSpacing: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: actions,
          ),
        );
      },
    );
  }
}