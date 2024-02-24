import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kingdomino_score_count/cubits/kingdom_cubit.dart';
import 'package:kingdomino_score_count/models/extensions/extension.dart';
import 'package:kingdomino_score_count/models/quests/quest.dart';
import 'package:provider/provider.dart';

import '../cubits/score_cubit.dart';
import '../cubits/theme_cubit.dart';
import 'highlight_box.dart';

class _QuestDialogOption extends StatefulWidget {
  final Function getSelectedQuests;
  final Function updateScores;
  final QuestType questType;
  final Widget svg;

  const _QuestDialogOption(
      this.questType, this.svg, this.getSelectedQuests, this.updateScores);

  @override
  _QuestDialogOptionState createState() => _QuestDialogOptionState();
}

class _QuestDialogOptionState extends State<_QuestDialogOption> {
  bool? _active;

  @override
  initState() {
    super.initState();
    _active = widget.getSelectedQuests().contains(widget.questType);
  }

  _QuestDialogOptionState();

  void _setActive(bool value) {
    setState(() {
      _active = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child = _active!
        ? Container(
            decoration: BoxDecoration(
                boxShadow: [highlightBox(context.read<ThemeCubit>().state)]),
            child: widget.svg)
        : widget.svg;

    return SimpleDialogOption(
      child: child,
      onPressed: () {
        setState(() {
          if (widget.getSelectedQuests().contains(widget.questType)) {
            _setActive(false);
            widget.getSelectedQuests().remove(widget.questType);
          } else if (widget.getSelectedQuests().length < 2) {
            _setActive(true);
            widget.getSelectedQuests().add(widget.questType);
          }
        });
        widget.updateScores(context.read<KingdomCubit>().state);
      },
    );
  }
}

class QuestDialogWidget extends StatefulWidget {
  final Function getSelectedQuests;
  final Function updateScores;
  final Function getExtension;

  const QuestDialogWidget(
      this.getSelectedQuests, this.updateScores, this.getExtension,
      {super.key});

  @override
  State<QuestDialogWidget> createState() => _QuestDialogWidgetState();
}

class _QuestDialogWidgetState extends State<QuestDialogWidget> {
  _QuestDialogWidgetState();

  @override
  build(BuildContext context) {
    var options = <Widget>[];

    if (widget.getExtension() == Extension.ageOfGiants) {
      questPicture.forEach((type, picture) {
        options.add(_QuestDialogOption(
            type,
            SvgPicture.asset('$assetsquestsLocation/$picture'),
            widget.getSelectedQuests,
            widget.updateScores));
      });
    } else {
      options.add(_QuestDialogOption(
          QuestType.harmony,
          SvgPicture.asset(
              '$assetsquestsLocation/${questPicture[QuestType.harmony]!}'),
          widget.getSelectedQuests,
          widget.updateScores));
      options.add(_QuestDialogOption(
          QuestType.middleKingdom,
          SvgPicture.asset(
              '$assetsquestsLocation/${questPicture[QuestType.middleKingdom]!}'),
          widget.getSelectedQuests,
          widget.updateScores));
    }

    SimpleDialog dialog = SimpleDialog(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 60,
        vertical: 40,
      ),
      children: options,
    );

    return Badge(
        isLabelVisible: widget.getSelectedQuests().length > 0,
        label: Text(widget.getSelectedQuests().length.toString()),
        child: IconButton(
            icon: const Icon(Icons.shield),
            onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) => Provider.value(
                    value: Provider.of<KingdomCubit>(context, listen: false),
                    child: Provider.value(
                        value: Provider.of<ScoreCubit>(context, listen: false),
                        child: dialog),
                  ),
                )));
  }
}
