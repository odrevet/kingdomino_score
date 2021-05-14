import 'package:flutter/material.dart';
import 'package:kingdomino_score_count/models/quests/quest.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

        this.updateScores();
      },
    );
  }
}

class QuestDialogWidget extends StatefulWidget {
  final getSelectedQuests;
  final updateScores;
  final getAog;

  QuestDialogWidget(this.getSelectedQuests, this.updateScores, this.getAog);

  @override
  _QuestDialogWidgetState createState() => _QuestDialogWidgetState(
      this.getSelectedQuests, this.updateScores, this.getAog);
}

class _QuestDialogWidgetState extends State<QuestDialogWidget> {
  final getSelectedQuests;
  final updateScores;
  final getAog;

  _QuestDialogWidgetState(
      this.getSelectedQuests, this.updateScores, this.getAog);

  @override
  build(BuildContext context) {
    var options = <Widget>[];

    if (getAog() == true) {
      questPicture.forEach((type, picture) {
        options.add(_QuestDialogOption(
            type,
            SvgPicture.asset('$assetsquestsLocation/$picture'),
            getSelectedQuests,
            updateScores));
      });
    } else {
      options.add(_QuestDialogOption(
          QuestType.harmony,
          SvgPicture.asset(
              '$assetsquestsLocation/${questPicture[QuestType.harmony]!}'),
          getSelectedQuests,
          updateScores));
      options.add(_QuestDialogOption(
          QuestType.middleKingdom,
          SvgPicture.asset(
              '$assetsquestsLocation/${questPicture[QuestType.middleKingdom]!}'),
          getSelectedQuests,
          updateScores));
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

    var button = IconButton(
        // Use the MdiIcons class for the IconData
        icon: Icon(Icons.shield),
        onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return dialog;
              },
            ));

    if (getSelectedQuests().isEmpty)
      return button;
    else
      return Stack(
        children: <Widget>[
          button,
          Positioned(
            right: 5,
            top: 10,
            child: Container(
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: BoxConstraints(
                minWidth: 12,
                minHeight: 12,
              ),
              child: Text(
                '${getSelectedQuests().length}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      );
  }
}
