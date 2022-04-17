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
  _QuestDialogOptionState createState() => _QuestDialogOptionState(
      this.questType, this.svg, this.getSelectedQuests, this.updateScores);
}

class _QuestDialogOptionState extends State<_QuestDialogOption> {
  final getSelectedQuests;
  final updateScores;
  final QuestType questType;
  final Widget svg;

  bool? _active;

  @override
  initState() {
    super.initState();
    _active = getSelectedQuests().contains(questType);
  }

  _QuestDialogOptionState(
      this.questType, this.svg, this.getSelectedQuests, this.updateScores);

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
            child: svg)
        : svg;

    return SimpleDialogOption(
      child: child,
      onPressed: () {
        setState(() {
          if (getSelectedQuests().contains(questType)) {
            _setActive(false);
            getSelectedQuests().remove(questType);
          } else if (getSelectedQuests().length < 2) {
            _setActive(true);
            getSelectedQuests().add(questType);
          }
        });
        context.read<ScoreCubit>().calculate(context.read<KingdomCubit>().state,
            null, getSelectedQuests()); //TODO getExtension
        //this.updateScores();
      },
    );
  }
}

class QuestDialogWidget extends StatefulWidget {
  final getSelectedQuests;
  final updateScores;
  final getExtension;

  QuestDialogWidget(
      this.getSelectedQuests, this.updateScores, this.getExtension);

  @override
  _QuestDialogWidgetState createState() => _QuestDialogWidgetState();
}

class _QuestDialogWidgetState extends State<QuestDialogWidget> {
  _QuestDialogWidgetState();

  @override
  build(BuildContext context) {
    var options = <Widget>[];

    if (widget.getExtension() == Extension.AgeOfGiants) {
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
      contentPadding: EdgeInsets.symmetric(
        horizontal: 60,
        vertical: 40,
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      children: options,
    );

    return Badge(
        showBadge: widget.getSelectedQuests().length > 0,
        position: BadgePosition.topEnd(top: -1, end: -1),
        badgeContent: Text(widget.getSelectedQuests().length.toString()),
        child: IconButton(
            icon: Icon(Icons.shield),
            onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return dialog;
                  },
                )));
  }
}
