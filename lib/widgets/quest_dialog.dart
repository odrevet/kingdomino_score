import 'package:flutter/material.dart';
import 'package:kingdomino_score_count/models/quest.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'main_widget.dart';

class _QuestDialogOption extends StatefulWidget {
  final MainWidgetState _mainWidgetState;
  final QuestType questType;
  final Widget svg;

  _QuestDialogOption(this.questType, this.svg, this._mainWidgetState);

  @override
  _QuestDialogOptionState createState() =>
      _QuestDialogOptionState(this.questType, this.svg, this._mainWidgetState);
}

class _QuestDialogOptionState extends State<_QuestDialogOption> {
  MainWidgetState _mainWidgetState;
  final QuestType questType;
  final Widget svg;

  bool _active;

  @override
  initState() {
    super.initState();
    _active = _mainWidgetState.selectedQuests.contains(questType);
  }

  _QuestDialogOptionState(this.questType, this.svg, this._mainWidgetState);

  void _setActive(bool value) {
    setState(() {
      _active = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child = _active
        ? Container(
            decoration: BoxDecoration(
                border: Border(
              top: BorderSide(width: 3, color: Colors.green.shade600),
              bottom: BorderSide(width: 3, color: Colors.green.shade600),
            )),
            child: svg)
        : svg;

    return SimpleDialogOption(
      child: child,
      onPressed: () {
        setState(() {
          if (_mainWidgetState.selectedQuests.contains(questType)) {
            _setActive(false);
            _mainWidgetState.selectedQuests.remove(questType);
          } else if (_mainWidgetState.selectedQuests.length < 2) {
            _setActive(true);
            _mainWidgetState.selectedQuests.add(questType);
          }
        });

        _mainWidgetState.updateScoreQuest();
        _mainWidgetState.updateScore();
      },
    );
  }
}

class QuestDialogWidget extends StatefulWidget {
  final MainWidgetState _mainWidgetState;

  QuestDialogWidget(this._mainWidgetState);

  @override
  _QuestDialogWidgetState createState() =>
      _QuestDialogWidgetState(this._mainWidgetState);
}

class _QuestDialogWidgetState extends State<QuestDialogWidget> {
  MainWidgetState _mainWidgetState;

  _QuestDialogWidgetState(this._mainWidgetState);

  @override
  build(BuildContext context) {
    var options = <Widget>[];

    options.add(_QuestDialogOption(QuestType.harmony,
        SvgPicture.asset('assets/harmony.svg'), _mainWidgetState));
    options.add(_QuestDialogOption(QuestType.middleKingdom,
        SvgPicture.asset('assets/template.svg'), _mainWidgetState));

    if (_mainWidgetState.aog == true) {
      options.add(Divider(
        height: 20,
        thickness: 5,
      ));
      options.add(_QuestDialogOption(QuestType.bleakKing,
          SvgPicture.asset('assets/template.svg'), _mainWidgetState));
      options.add(_QuestDialogOption(QuestType.lostCorner,
          SvgPicture.asset('assets/template.svg'), _mainWidgetState));
      options.add(Divider(
        height: 20,
        thickness: 5,
      ));
      options.add(_QuestDialogOption(QuestType.folieDesGrandeurs,
          SvgPicture.asset('assets/template.svg'), _mainWidgetState));
      options.add(_QuestDialogOption(QuestType.fourCornersWheat,
          SvgPicture.asset('assets/template.svg'), _mainWidgetState));
      options.add(_QuestDialogOption(QuestType.fourCornersLake,
          SvgPicture.asset('assets/template.svg'), _mainWidgetState));
      options.add(_QuestDialogOption(QuestType.fourCornersForest,
          SvgPicture.asset('assets/template.svg'), _mainWidgetState));
      options.add(_QuestDialogOption(QuestType.fourCornersGrassLand,
          SvgPicture.asset('assets/template.svg'), _mainWidgetState));
      options.add(_QuestDialogOption(QuestType.fourCornersSwamp,
          SvgPicture.asset('assets/template.svg'), _mainWidgetState));
      options.add(_QuestDialogOption(QuestType.fourCornersMine,
          SvgPicture.asset('assets/template.svg'), _mainWidgetState));
      options.add(Divider(
        height: 20,
        thickness: 5,
      ));
      options.add(_QuestDialogOption(QuestType.localBusinessWheat,
          SvgPicture.asset('assets/template.svg'), _mainWidgetState));
      options.add(_QuestDialogOption(QuestType.localBusinessLake,
          SvgPicture.asset('assets/template.svg'), _mainWidgetState));
      options.add(_QuestDialogOption(QuestType.localBusinessForest,
          SvgPicture.asset('assets/template.svg'), _mainWidgetState));
      options.add(_QuestDialogOption(QuestType.localBusinessGrassLand,
          SvgPicture.asset('assets/template.svg'), _mainWidgetState));
      options.add(_QuestDialogOption(QuestType.localBusinessSwamp,
          SvgPicture.asset('assets/template.svg'), _mainWidgetState));
      options.add(_QuestDialogOption(QuestType.localBusinessMine,
          SvgPicture.asset('assets/template.svg'), _mainWidgetState));
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
        icon: Icon(MdiIcons.shieldOutline),
        onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return dialog;
              },
            ));

    if (_mainWidgetState.selectedQuests.isEmpty)
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
                '${_mainWidgetState.selectedQuests.length}',
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
