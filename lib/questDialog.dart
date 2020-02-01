import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'ageOfGiants.dart';
import 'kingdom.dart';
import 'mainWidget.dart';
import 'quest.dart';
import 'quests/fourCorners.dart';
import 'quests/localBusiness.dart';

class _QuestDialogOption extends StatefulWidget {
  final MainWidgetState _mainWidgetState;
  final QuestWidget questWidget;

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
    super.initState();
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
    Widget child = _active
        ? Container(
            decoration: BoxDecoration(
                border: Border(
              right: BorderSide(width: 3, color: Colors.red.shade600),
              top: BorderSide(width: 3, color: Colors.red.shade600),
              left: BorderSide(width: 3, color: Colors.red.shade600),
              bottom: BorderSide(width: 3, color: Colors.red.shade600),
            )),
            child: questWidget)
        : questWidget;

    return SimpleDialogOption(
      child: child,
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
  final MainWidgetState _mainWidgetState;

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
