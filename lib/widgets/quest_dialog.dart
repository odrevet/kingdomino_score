import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kingdomino_score_count/cubits/kingdom_cubit.dart';
import 'package:kingdomino_score_count/models/extension.dart';
import 'package:kingdomino_score_count/models/quests/quest.dart';

import '../cubits/score_cubit.dart';

class _QuestDialogOption extends StatefulWidget {
  final getSelectedQuests;
  final updateScores;
  final QuestType questType;
  final Widget svg;

  _QuestDialogOption(
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
                border: Border(
              left: BorderSide(width: 3, color: Colors.green.shade600),
              right: BorderSide(width: 3, color: Colors.green.shade600),
            )),
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
        context.read<ScoreCubit>().calculate(context.read<KingdomCubit>().state,
            null, widget.getSelectedQuests()); //TODO getExtension
        //this.updateScores();
      },
    );
  }
}

class QuestDialogWidget extends StatefulWidget {
  final getSelectedQuests;
  final updateScores;
  final getExtension;

  const QuestDialogWidget(
      this.getSelectedQuests, this.updateScores, this.getExtension);

  @override
  _QuestDialogWidgetState createState() => _QuestDialogWidgetState();
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
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      children: options,
    );

    return Badge(
        showBadge: widget.getSelectedQuests().length > 0,
        position: BadgePosition.topEnd(top: -1, end: -1),
        badgeContent: Text(widget.getSelectedQuests().length.toString()),
        child: IconButton(
            icon: const Icon(Icons.shield),
            onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return dialog;
                  },
                )));
  }
}
