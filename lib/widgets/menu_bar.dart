import 'package:flutter/material.dart';

import '../models/age_of_giants.dart';
import '../models/kingdom.dart';
import 'giant_details_widget.dart';
import 'kingdom_widget.dart';
import 'main_widget.dart';

class MenuBar extends StatefulWidget {
  final MainWidgetState _mainWidgetState;

  MenuBar(this._mainWidgetState);

  @override
  _MenuBarState createState() => _MenuBarState(this._mainWidgetState);
}

class _MenuBarState extends State<MenuBar> {
  MainWidgetState _mainWidgetState;

  _MenuBarState(this._mainWidgetState);

  final double _buttonSize = 40.0;

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

    if (_mainWidgetState.aog) kingdomEditorWidgets.add(giantButton());

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
    var isSelected = _mainWidgetState.selectionMode == SelectionMode.land &&
        _mainWidgetState.selectedLandType == landType;

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
                        : _mainWidgetState.outline),
            child: Container(
              color: getColorForLandType(landType),
              child: null,
            )));
  }

  _colorbutton(Color color) {
    return GestureDetector(
        onTap: () => setState(() {
              _mainWidgetState..color = color;
            }),
        child: Container(
          margin: EdgeInsets.all(5.0),
          height: _buttonSize,
          width: _buttonSize,
          decoration: BoxDecoration(color: color),
          child: Container(),
        ));
  }

  Widget castleButton() {
    bool isSelected = _mainWidgetState.selectionMode == SelectionMode.castle &&
        _mainWidgetState.selectedLandType == LandType.castle;

    return GestureDetector(
        onTap: () => setState(() {
              _mainWidgetState.selectionMode = SelectionMode.castle;
              _mainWidgetState.selectedLandType = LandType.castle;
            }),
        onLongPress: () {
          var buttons = <Widget>[
            _colorbutton(Colors.yellow),
            _colorbutton(Colors.blue),
            _colorbutton(Colors.green),
            _colorbutton(Colors.pink)
          ];

          if (_mainWidgetState.aog == true) {
            buttons.add(_colorbutton(Colors.brown));
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
        },
        child: Container(
          margin: EdgeInsets.all(5.0),
          height: _buttonSize,
          width: _buttonSize,
          decoration: BoxDecoration(
              color: _mainWidgetState.color,
              border: isSelected ? _selectedBorder : _mainWidgetState.outline),
          child: FittedBox(fit: BoxFit.fitHeight, child: Text(castle)),
        ));
  }

  Widget crownButton() {
    var isSelected = _mainWidgetState.selectionMode == SelectionMode.crown;

    return GestureDetector(
        onTap: () => _onSelectCrown(),
        child: Container(
          margin: EdgeInsets.all(5.0),
          height: _buttonSize,
          width: _buttonSize,
          decoration: BoxDecoration(
              border: isSelected ? _selectedBorder : _mainWidgetState.outline),
          child: FittedBox(fit: BoxFit.fitHeight, child: Text(crown)),
        ));
  }

  Widget giantButton() {
    var isSelected = _mainWidgetState.selectionMode == SelectionMode.giant;

    return GestureDetector(
        onTap: () => _onSelectGiant(),
        onLongPress: () => _mainWidgetState.runDialog(
            GiantsDetailsWidget(
              kingdom: _mainWidgetState.kingdom,
              scoreOfQuest: _mainWidgetState.scoreOfQuest,
              quests: _mainWidgetState.quests,
              groupScore: _mainWidgetState.groupScore,
              score: _mainWidgetState.score
            ),
            context),
        child: Container(
          margin: EdgeInsets.all(5.0),
          height: _buttonSize,
          width: _buttonSize,
          decoration: BoxDecoration(
              border: isSelected ? _selectedBorder : _mainWidgetState.outline),
          child: FittedBox(fit: BoxFit.fitHeight, child: Text(giant)),
        ));
  }

  //CALLBACKS
  void _onSelectLandType(LandType selectedType) {
    if (selectedType == LandType.castle)
      _onSelectCastle();
    else
      setState(() {
        _mainWidgetState.selectedLandType = selectedType;
        _mainWidgetState.selectionMode = SelectionMode.land;
      });
  }

  void _onSelectCrown() {
    setState(() {
      _mainWidgetState.selectionMode = SelectionMode.crown;
    });
  }

  void _onSelectCastle() {
    setState(() {
      _mainWidgetState.selectedLandType = LandType.castle;
      _mainWidgetState.selectionMode = SelectionMode.castle;
    });
  }

  void _onSelectGiant() {
    setState(() {
      _mainWidgetState.selectionMode = SelectionMode.giant;
    });
  }
}
