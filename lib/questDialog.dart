import 'package:flutter/material.dart';

import 'kingdom.dart';
import 'quest.dart';
import 'ageOfGiants.dart';
import 'main.dart';

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

  _questDialogAddOption(List<Widget> options, QuestWidget questWidget) {
    options.add(
      SimpleDialogOption(
        child: _mainWidgetState.quests.contains(questWidget.quest)
            ? Container(
                decoration: new BoxDecoration(
                    border: new Border.all(color: Colors.blueAccent)),
                child: questWidget)
            : questWidget,
        onPressed: () {
          setState(() {
            if (_mainWidgetState.quests.contains(questWidget.quest))
              _mainWidgetState.quests.remove(questWidget.quest);
            else if (_mainWidgetState.quests.length < 2)
              _mainWidgetState.quests.add(questWidget.quest);
          });

          _mainWidgetState.updateScoreQuest();
          _mainWidgetState.updateScore();
        },
      ),
    );
  }

  @override
  build(BuildContext context) {
    var options = <Widget>[];

    _questDialogAddOption(options, harmonyWidget);
    _questDialogAddOption(options, middleKingdomWidget);

    if (_mainWidgetState.aog == true) {
      _questDialogAddOption(options, localBusinessWheatWidget);
      _questDialogAddOption(options, localBusinessGrasslandWidget);
      _questDialogAddOption(options, localBusinessForestWidget);
      _questDialogAddOption(options, localBusinessLakeWidget);
      _questDialogAddOption(options, localBusinessMineWidget);
      _questDialogAddOption(options, localBusinessSwampWidget);

      _questDialogAddOption(options, fourCornersWheatWidget);
      _questDialogAddOption(options, fourCornersGrasslandWidget);
      _questDialogAddOption(options, fourCornersForestWidget);
      _questDialogAddOption(options, fourCornersLakeWidget);
      _questDialogAddOption(options, fourCornersMineWidget);
      _questDialogAddOption(options, fourCornersSwampWidget);

      _questDialogAddOption(options, lostCornerWidget);
      _questDialogAddOption(options, folieDesGrandeursWidget);
      _questDialogAddOption(options, bleakKingWidget);
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
