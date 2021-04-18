import 'package:flutter/material.dart';

import '../models/age_of_giants.dart';
import '../models/kingdom.dart';
import 'giant_details_widget.dart';
import 'kingdom_widget.dart';
import 'kingdomino_score_widget.dart';

class BottomBar extends StatefulWidget {
  final getSelectionMode;
  final setSelectionMode;
  final getSelectedLandType;
  final setSelectedLandType;
  final getAog;
  final Kingdom kingdom;
  final groupScore;
  final quests;
  final scoreOfQuest;
  final score;

  BottomBar(
      {required this.getSelectionMode,
      required this.setSelectionMode,
      required this.getSelectedLandType,
      required this.setSelectedLandType,
      required this.getAog,
      required this.kingdom,
      required this.quests,
      required this.groupScore,
      required this.scoreOfQuest,
      required this.score});

  @override
  _BottomBarState createState() => _BottomBarState(
      getSelectionMode: this.getSelectionMode,
      setSelectionMode: this.setSelectionMode,
      getSelectedLandType: this.getSelectedLandType,
      setSelectedLandType: this.setSelectedLandType,
      getAog: this.getAog,
      scoreOfQuest: this.scoreOfQuest,
      quests: this.quests,
      groupScore: this.groupScore,
      score: this.score,
      kingdom: kingdom);
}

class _BottomBarState extends State<BottomBar> {
  final getSelectionMode;
  final setSelectionMode;
  final getSelectedLandType;
  final setSelectedLandType;
  final getAog;
  final Kingdom kingdom;
  final groupScore;
  final quests;
  final scoreOfQuest;
  final score;

  _BottomBarState(
      {required this.getSelectionMode,
      required this.setSelectionMode,
      required this.getSelectedLandType,
      required this.setSelectedLandType,
      required this.getAog,
      required this.kingdom,
      required this.quests,
      required this.groupScore,
      required this.scoreOfQuest,
      required this.score});

  final double _buttonSize = 40.0;

  var outline = Border(
    right: BorderSide(width: 3.5, color: Colors.blueGrey.shade600),
    bottom: BorderSide(width: 3.5, color: Colors.blueGrey.shade900),
  );

  @override
  Widget build(BuildContext context) {
    var kingdomEditorWidgets = [
      landButton(LandType.wheat),
      landButton(LandType.grassland),
      landButton(LandType.forest),
      landButton(LandType.lake),
      landButton(LandType.swamp),
      landButton(LandType.mine),
      landButton(LandType.none),
      castleButton(),
      crownButton(),
    ];

    if (this.getAog()) kingdomEditorWidgets.add(giantButton());

    return Wrap(
      children: kingdomEditorWidgets,
    );
  }

  Border _selectedBorder = Border(
    right: BorderSide(width: 3.5, color: Colors.red.shade600),
    top: BorderSide(width: 3.5, color: Colors.red.shade600),
    left: BorderSide(width: 3.5, color: Colors.red.shade600),
    bottom: BorderSide(width: 3.5, color: Colors.red.shade900),
  );

  Widget landButton(LandType landType) {
    var isSelected = this.getSelectionMode() == SelectionMode.land &&
        this.getSelectedLandType() == landType;

    return GestureDetector(
        onTap: () => _onSelectLandType(landType),
        child: Container(
            margin: EdgeInsets.all(5.0),
            height: _buttonSize,
            width: _buttonSize,
            decoration: BoxDecoration(
                border: isSelected
                    ? _selectedBorder
                    : landType == LandType.none
                        ? null
                        : this.outline),
            child: Container(
              color: getColorForLandType(landType),
              child: null,
            )));
  }

  /*_colorbutton(Color kingcolor) {
    return GestureDetector(
        onTap: () => setState(() {
              _mainWidgetState.kingColor = kingcolor;
            }),
        child: Container(
          margin: EdgeInsets.all(5.0),
          height: _buttonSize,
          width: _buttonSize,
          decoration: BoxDecoration(color: kingcolor),
          child: Container(),
        ));
  }*/

  Widget castleButton() {
    bool isSelected = this.getSelectionMode() == SelectionMode.castle &&
        this.getSelectedLandType() == LandType.castle;

    return GestureDetector(
        onTap: () => setState(() {
              this.setSelectionMode(SelectionMode.castle);
              this.setSelectedLandType(LandType.castle);
            }),
        /*onLongPress: () {
          var buttons = <Widget>[
            _colorbutton(KingColors.elementAt(0)),
            _colorbutton(KingColors.elementAt(1)),
            _colorbutton(KingColors.elementAt(2)),
            _colorbutton(KingColors.elementAt(3)),
            _colorbutton(KingColors.elementAt(4)),
          ];

          if (_mainWidgetState.aog == true) {
            buttons.add(_colorbutton(KingColors.elementAt(5)));
          }

          showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    content: Wrap(
                      children: buttons,
                    ),
                  );
                },
              );
            },
          );
        },*/
        child: Container(
          margin: EdgeInsets.all(5.0),
          height: _buttonSize,
          width: _buttonSize,
          decoration: BoxDecoration(
              color: Colors.white,
              border: isSelected ? _selectedBorder : this.outline),
          child: CastleWidget(KingColors.elementAt(0)),
        ));
  }

  Widget crownButton() {
    var isSelected = this.getSelectionMode() == SelectionMode.crown;

    return GestureDetector(
        onTap: () => _onSelectCrown(),
        child: Container(
          margin: EdgeInsets.all(5.0),
          height: _buttonSize,
          width: _buttonSize,
          decoration: BoxDecoration(
              border: isSelected ? _selectedBorder : this.outline),
          child: FittedBox(fit: BoxFit.fitHeight, child: Text(crown)),
        ));
  }

  Widget giantButton() {
    var isSelected = this.getSelectionMode() == SelectionMode.giant;

    return GestureDetector(
        onTap: () => _onSelectGiant(),
        onLongPress: () => showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  content: GiantsDetailsWidget(this.kingdom,
                      scoreOfQuest: this.scoreOfQuest,
                      quests: this.quests,
                      groupScore: this.groupScore,
                      score: this.score),
                  actions: <Widget>[
                    TextButton(
                      child: Icon(
                        Icons.done,
                        color: Colors.black87,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            ),
        child: Container(
          margin: EdgeInsets.all(5.0),
          height: _buttonSize,
          width: _buttonSize,
          decoration: BoxDecoration(
              border: isSelected ? _selectedBorder : this.outline),
          child: FittedBox(fit: BoxFit.fitHeight, child: Text(giant)),
        ));
  }

  //CALLBACKS
  void _onSelectLandType(LandType selectedType) {
    if (selectedType == LandType.castle)
      _onSelectCastle();
    else
      setState(() {
        this.setSelectedLandType(selectedType);
        this.setSelectionMode(SelectionMode.land);
      });
  }

  void _onSelectCrown() {
    setState(() {
      this.setSelectionMode(SelectionMode.crown);
    });
  }

  void _onSelectCastle() {
    setState(() {
      this.setSelectedLandType(LandType.castle);
      this.setSelectionMode(SelectionMode.castle);
    });
  }

  void _onSelectGiant() {
    setState(() {
      this.setSelectionMode(SelectionMode.giant);
    });
  }
}
