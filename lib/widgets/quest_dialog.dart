import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kingdomino_score_count/cubits/kingdom_cubit.dart';
import 'package:kingdomino_score_count/models/extensions/extension.dart';
import 'package:kingdomino_score_count/models/quests/quest.dart';
import 'package:provider/provider.dart';

import '../cubits/game_cubit.dart';
import '../cubits/rules_cubit.dart';
import '../cubits/theme_cubit.dart';
import '../models/game_set.dart';
import '../models/rules.dart';
import 'highlight_box.dart';

class _QuestDialogOption extends StatefulWidget {
  final QuestType questType;
  final Widget svg;

  const _QuestDialogOption(this.questType, this.svg);

  @override
  _QuestDialogOptionState createState() => _QuestDialogOptionState();
}

class _QuestDialogOptionState extends State<_QuestDialogOption> {
  _QuestDialogOptionState();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RulesCubit, Rules>(
      builder: (context, rules) {
        final isSelected = rules.selectedQuests.contains(widget.questType);

        return BlocBuilder<ThemeCubit, Color>(
          builder: (context, themeColor) {
            Widget child = isSelected
                ? Container(
                    decoration: BoxDecoration(
                      boxShadow: [highlightBox(themeColor)],
                    ),
                    child: widget.svg,
                  )
                : widget.svg;

            return SimpleDialogOption(
              child: child,
              onPressed: () {
                context.read<RulesCubit>().toggleQuest(widget.questType);
                for (final kingColor in KingColor.values) {
                  context.read<GameCubit>().calculateScore(
                      kingColor,
                      getKingdomCubit(context, kingColor).state,
                      context.read<RulesCubit>().state);
                }
              },
            );
          },
        );
      },
    );
  }
}

class QuestDialogWidget extends StatefulWidget {
  const QuestDialogWidget({super.key});

  @override
  State<QuestDialogWidget> createState() => _QuestDialogWidgetState();
}

class _QuestDialogWidgetState extends State<QuestDialogWidget> {
  _QuestDialogWidgetState();

  @override
  build(BuildContext context) {
    var options = <Widget>[];

    if (context.read<RulesCubit>().state.extension == Extension.ageOfGiants) {
      questPicture.forEach((type, picture) {
        options.add(_QuestDialogOption(
            type, SvgPicture.asset('$assetsquestsLocation/$picture')));
      });
    } else {
      options.add(_QuestDialogOption(
          QuestType.harmony,
          SvgPicture.asset(
              '$assetsquestsLocation/${questPicture[QuestType.harmony]!}')));
      options.add(_QuestDialogOption(
          QuestType.middleKingdom,
          SvgPicture.asset(
              '$assetsquestsLocation/${questPicture[QuestType.middleKingdom]!}')));
    }

    SimpleDialog dialog = SimpleDialog(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 60,
        vertical: 40,
      ),
      children: options,
    );

    return Badge(
        isLabelVisible:
            context.read<RulesCubit>().state.selectedQuests.isNotEmpty,
        label: Text(
            context.read<RulesCubit>().state.selectedQuests.length.toString()),
        child: IconButton(
            icon: const Icon(Icons.shield),
            onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) => MultiProvider(
                    providers: [
                      Provider.value(
                        value: Provider.of<KingdomCubitPink>(context,
                            listen: false),
                      ),
                      Provider.value(
                        value: Provider.of<KingdomCubitYellow>(context,
                            listen: false),
                      ),
                      Provider.value(
                        value: Provider.of<KingdomCubitGreen>(context,
                            listen: false),
                      ),
                      Provider.value(
                        value: Provider.of<KingdomCubitBlue>(context,
                            listen: false),
                      ),
                      Provider.value(
                        value: Provider.of<KingdomCubitBrown>(context,
                            listen: false),
                      ),
                      Provider.value(
                        value: Provider.of<GameCubit>(context, listen: false),
                      ),
                      Provider.value(
                        value: Provider.of<RulesCubit>(context, listen: false),
                      ),
                    ],
                    child: dialog,
                  ),
                )));
  }
}
