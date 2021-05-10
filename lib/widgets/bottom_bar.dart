import 'package:flutter/material.dart';

import '../models/land.dart' show LandType;
import '../models/age_of_giants.dart';
import '../models/kingdom.dart';
import '../models/lacour/lacour.dart';
import '../models/land.dart';
import 'giant_details_widget.dart';
import 'kingdom_widget.dart';
import 'kingdomino_score_widget.dart';


class BottomBar extends StatefulWidget {
  final getSelectionMode;
  final setSelectionMode;
  final getSelectedLandType;
  final setSelectedLandType;
  final getSelectedCourtierType;
  final setSelectedCourtierType;
  final getKingColor;
  final setKingColor;
  final getAog;
  final getLacour;
  final Kingdom kingdom;
  final groupScore;
  final quests;
  final scoreOfQuest;
  final score;

  BottomBar({required this.getSelectionMode,
    required this.setSelectionMode,
    required this.getSelectedLandType,
    required this.setSelectedLandType,
    required this.getSelectedCourtierType,
    required this.setSelectedCourtierType,
    required this.getAog,
    required this.getLacour,
    required this.kingdom,
    required this.quests,
    required this.groupScore,
    required this.scoreOfQuest,
    required this.score,
    required this.getKingColor,
    required this.setKingColor});

  @override
  _BottomBarState createState() =>
      _BottomBarState(
          getSelectionMode: this.getSelectionMode,
          setSelectionMode: this.setSelectionMode,
          getSelectedLandType: this.getSelectedLandType,
          setSelectedLandType: this.setSelectedLandType,
          getSelectedCourtierType: this.getSelectedCourtierType,
          setSelectedCourtierType: this.setSelectedCourtierType,
          getAog: this.getAog,
          getLacour: this.getLacour,
          scoreOfQuest: this.scoreOfQuest,
          quests: this.quests,
          groupScore: this.groupScore,
          score: this.score,
          kingdom: kingdom,
          getKingColor: this.getKingColor,
          setKingColor: this.setKingColor);
}

class _BottomBarState extends State<BottomBar> {
  final getSelectionMode;
  final setSelectionMode;
  final getSelectedLandType;
  final setSelectedLandType;
  final getSelectedCourtierType;
  final setSelectedCourtierType;
  final setKingColor;
  final getKingColor;
  final getAog;
  final getLacour;
  final Kingdom kingdom;
  final groupScore;
  final quests;
  final scoreOfQuest;
  final score;

  _BottomBarState({required this.getSelectionMode,
    required this.setSelectionMode,
    required this.getSelectedLandType,
    required this.setSelectedLandType,
    required this.getSelectedCourtierType,
    required this.setSelectedCourtierType,
    required this.getAog,
    required this.getLacour,
    required this.kingdom,
    required this.quests,
    required this.groupScore,
    required this.scoreOfQuest,
    required this.score,
    required this.getKingColor,
    required this.setKingColor});

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
      landButton(null),
      castleButton(),
      crownButton(),
    ];

    if (this.getAog()) kingdomEditorWidgets.add(giantButton());

    if (this.getLacour() == true) {
      kingdomEditorWidgets.add(resourceButton());

      CourtierType.values.forEach((element) {
        kingdomEditorWidgets.add(courtierButton(element));
      });
    }

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

  Widget landButton(LandType? landType) {
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
                    : landType == null
                    ? null
                    : this.outline),
            child: Container(
              color: getColorForLandType(landType),
              child: null,
            )));
  }

  Widget resourceButton() {
    var isSelected = this.getSelectionMode() == SelectionMode.resource;

    return GestureDetector(
        onTap: () => setSelectionMode(SelectionMode.resource),
        child: Container(
            margin: EdgeInsets.all(5.0),
            height: _buttonSize,
            width: _buttonSize,
            decoration: BoxDecoration(border: isSelected ? _selectedBorder : this.outline),
            child: Align(alignment: Alignment.center, child: Text('⬤'))));
  }

  Widget courtierButton(CourtierType courtierType) {
    var isSelected = this.getSelectionMode() == SelectionMode.courtier &&
        this.getSelectedCourtierType() == courtierType;

    return GestureDetector(
        onTap: () => _onSelectCourtierType(courtierType),
        child: Container(
            margin: EdgeInsets.all(5.0),
            height: _buttonSize,
            width: _buttonSize,
            decoration: BoxDecoration(border: isSelected ? _selectedBorder : this.outline),
            child: Image(
                height: 50,
                width: 50,
                image: AssetImage(courtierPicture[courtierType]!))));
  }

  _colorbutton(Color? kingcolor) {
    return GestureDetector(
        onTap: () => setKingColor(kingcolor),
        child: Container(
          margin: EdgeInsets.all(5.0),
          height: _buttonSize,
          width: _buttonSize,
          decoration: BoxDecoration(color: kingcolor ?? Colors.white),
          child: Container(),
        ));
  }

  Widget castleButton() {
    bool isSelected = this.getSelectionMode() == SelectionMode.castle &&
        this.getSelectedLandType() == LandType.castle;

    return GestureDetector(
        onTap: () =>
            setState(() {
              this.setSelectionMode(SelectionMode.castle);
              this.setSelectedLandType(LandType.castle);
            }),
        onLongPress: () {
          setState(() {
            this.setSelectionMode(SelectionMode.castle);
            this.setSelectedLandType(LandType.castle);
          });

          var buttons = <Widget>[
            _colorbutton(null),
            _colorbutton(kingColors.elementAt(0)),
            _colorbutton(kingColors.elementAt(1)),
            _colorbutton(kingColors.elementAt(2)),
            _colorbutton(kingColors.elementAt(3)),
          ];

          if (this.getAog() == true) {
            buttons.add(_colorbutton(kingColors.elementAt(4)));
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
              color: Colors.white,
              border: isSelected ? _selectedBorder : this.outline),
          child: CastleWidget(this.getKingColor()),
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
        onLongPress: () =>
            showDialog<void>(
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
  void _onSelectLandType(LandType? selectedType) {
    if (selectedType == LandType.castle)
      _onSelectCastle();
    else
      setState(() {
        this.setSelectedLandType(selectedType);
        this.setSelectionMode(SelectionMode.land);
      });
  }

  void _onSelectCourtierType(CourtierType selectedType) {
    setState(() {
      this.setSelectedCourtierType(selectedType);
      this.setSelectionMode(SelectionMode.courtier);
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
