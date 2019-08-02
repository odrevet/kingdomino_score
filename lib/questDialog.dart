import 'package:flutter/material.dart';

import 'kingdom.dart';
import 'quest.dart';
import 'ageOfGiants.dart';
import 'main.dart';

class _QuestDialogOption extends StatefulWidget {
  MainWidgetState _mainWidgetState;
  QuestWidget questWidget;

  _QuestDialogOption(this.questWidget, this._mainWidgetState);

  @override
  _QuestDialogOptionState createState() =>
      _QuestDialogOptionState(this.questWidget, this._mainWidgetState);
}

class _QuestDialogOptionState extends State<_QuestDialogOption> {
  MainWidgetState _mainWidgetState;
  final QuestWidget questWidget;

  bool _active;

  @override
  initState() {
    _active = _mainWidgetState.quests.contains(questWidget.quest);
  }

  _QuestDialogOptionState(this.questWidget, this._mainWidgetState);

  void _setActive(bool value) {
    setState(() {
      _active = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      child: _active
          ? Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.red)),
              child: questWidget)
          : questWidget,
      onPressed: () {
        setState(() {
          if (_mainWidgetState.quests.contains(questWidget.quest)) {
            _setActive(false);
            _mainWidgetState.quests.remove(questWidget.quest);
          } else if (_mainWidgetState.quests.length < 2) {
            _setActive(true);
            _mainWidgetState.quests.add(questWidget.quest);
          }
        });

        _mainWidgetState.updateScoreQuest();
        _mainWidgetState.updateScore();
      },
    );
  }
}

class QuestDialogWidget extends StatefulWidget {
  MainWidgetState _mainWidgetState;

  QuestDialogWidget(this._mainWidgetState);

  @override
  _QuestDialogWidgetState createState() =>
      _QuestDialogWidgetState(this._mainWidgetState);
}

class _QuestDialogWidgetState extends State<QuestDialogWidget> {
  MainWidgetState _mainWidgetState;

  _QuestDialogWidgetState(this._mainWidgetState);

  static final harmonyWidget = HarmonyWidget();
  static final middleKingdomWidget = MiddleKingdomWidget();

  static final localBusinessWheatWidget =
      LocalBusinessWidget(LocalBusiness(LandType.wheat));
  static final localBusinessGrasslandWidget =
      LocalBusinessWidget(LocalBusiness(LandType.grassland));
  static final localBusinessForestWidget =
      LocalBusinessWidget(LocalBusiness(LandType.forest));
  static final localBusinessLakeWidget =
      LocalBusinessWidget(LocalBusiness(LandType.lake));
  static final localBusinessMineWidget =
      LocalBusinessWidget(LocalBusiness(LandType.mine));
  static final localBusinessSwampWidget =
      LocalBusinessWidget(LocalBusiness(LandType.swamp));

  static final fourCornersWheatWidget =
      FourCornersWidget(FourCorners(LandType.wheat));
  static final fourCornersGrasslandWidget =
      FourCornersWidget(FourCorners(LandType.grassland));
  static final fourCornersForestWidget =
      FourCornersWidget(FourCorners(LandType.forest));
  static final fourCornersLakeWidget =
      FourCornersWidget(FourCorners(LandType.lake));
  static final fourCornersMineWidget =
      FourCornersWidget(FourCorners(LandType.mine));
  static final fourCornersSwampWidget =
      FourCornersWidget(FourCorners(LandType.swamp));

  static final lostCornerWidget = LostCornerWidget();
  static final folieDesGrandeursWidget = FolieDesGrandeursWidget();
  static final bleakKingWidget = BleakKingWidget();

  @override
  build(BuildContext context) {
    var options = <Widget>[];

    options.add(_QuestDialogOption(harmonyWidget, _mainWidgetState));
    options.add(_QuestDialogOption(middleKingdomWidget, _mainWidgetState));

    if (_mainWidgetState.aog == true) {
      options
          .add(_QuestDialogOption(localBusinessWheatWidget, _mainWidgetState));
      options.add(
          _QuestDialogOption(localBusinessGrasslandWidget, _mainWidgetState));
      options
          .add(_QuestDialogOption(localBusinessForestWidget, _mainWidgetState));
      options
          .add(_QuestDialogOption(localBusinessLakeWidget, _mainWidgetState));
      options
          .add(_QuestDialogOption(localBusinessMineWidget, _mainWidgetState));
      options
          .add(_QuestDialogOption(localBusinessSwampWidget, _mainWidgetState));

      options.add(_QuestDialogOption(fourCornersWheatWidget, _mainWidgetState));
      options.add(
          _QuestDialogOption(fourCornersGrasslandWidget, _mainWidgetState));
      options
          .add(_QuestDialogOption(fourCornersForestWidget, _mainWidgetState));
      options.add(_QuestDialogOption(fourCornersLakeWidget, _mainWidgetState));
      options.add(_QuestDialogOption(fourCornersMineWidget, _mainWidgetState));
      options.add(_QuestDialogOption(fourCornersSwampWidget, _mainWidgetState));

      options.add(_QuestDialogOption(lostCornerWidget, _mainWidgetState));
      options
          .add(_QuestDialogOption(folieDesGrandeursWidget, _mainWidgetState));
      options.add(_QuestDialogOption(bleakKingWidget, _mainWidgetState));
    }

    SimpleDialog dialog = SimpleDialog(
      children: options,
    );

    var button = MaterialButton(
        minWidth: 30,
        onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return dialog;
              },
            ),
        child: Container(child: Text(shield, style: TextStyle(fontSize: 30))));

    if (_mainWidgetState.quests.isEmpty)
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
                '${_mainWidgetState.quests.length}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      );
  }
}
