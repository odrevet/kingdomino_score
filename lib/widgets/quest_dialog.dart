import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kingdomino_score_count/cubits/kingdom_cubit.dart';
import 'package:kingdomino_score_count/models/extensions/extension.dart';
import 'package:kingdomino_score_count/models/quests/quest.dart';
import 'package:provider/provider.dart';

import '../cubits/game_cubit.dart';
import '../cubits/theme_cubit.dart';
import '../models/game.dart';
import 'highlight_box.dart';

class _QuestDialogOption extends StatefulWidget {
  final Function refreshWarnings;
  final QuestType questType;
  final Widget svg;

  const _QuestDialogOption(this.questType, this.svg, this.refreshWarnings);

  @override
  _QuestDialogOptionState createState() => _QuestDialogOptionState();
}

class _QuestDialogOptionState extends State<_QuestDialogOption> {
  _QuestDialogOptionState();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, Game>(
      builder: (context, game) {
        final isSelected = game.selectedQuests.contains(widget.questType);

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
                context.read<GameCubit>().toggleQuest(widget.questType);
                widget.refreshWarnings(context.read<KingdomCubit>().state);
                context.read<GameCubit>().calculateScore(context.read<KingdomCubit>().state);
              },
            );
          },
        );
      },
    );
  }
}

class QuestDialogWidget extends StatefulWidget {
  final Function refreshWarnings;

  const QuestDialogWidget(this.refreshWarnings, {super.key});

  @override
  State<QuestDialogWidget> createState() => _QuestDialogWidgetState();
}

class _QuestDialogWidgetState extends State<QuestDialogWidget> {
  _QuestDialogWidgetState();

  @override
  build(BuildContext context) {
    var options = <Widget>[];

    if (context.read<GameCubit>().state.extension == Extension.ageOfGiants) {
      questPicture.forEach((type, picture) {
        options.add(_QuestDialogOption(
            type,
            SvgPicture.asset('$assetsquestsLocation/$picture'),
            widget.refreshWarnings));
      });
    } else {
      options.add(_QuestDialogOption(
          QuestType.harmony,
          SvgPicture.asset(
              '$assetsquestsLocation/${questPicture[QuestType.harmony]!}'),
          widget.refreshWarnings));
      options.add(_QuestDialogOption(
          QuestType.middleKingdom,
          SvgPicture.asset(
              '$assetsquestsLocation/${questPicture[QuestType.middleKingdom]!}'),
          widget.refreshWarnings));
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
            context.read<GameCubit>().state.getSelectedQuests().isNotEmpty,
        label: Text(context
            .read<GameCubit>()
            .state
            .getSelectedQuests()
            .length
            .toString()),
        child: IconButton(
            icon: const Icon(Icons.shield),
            onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) => Provider.value(
                    value: Provider.of<KingdomCubit>(context, listen: false),
                    child: Provider.value(
                        value: Provider.of<GameCubit>(context, listen: false),
                        child: dialog),
                  ),
                )));
  }
}
