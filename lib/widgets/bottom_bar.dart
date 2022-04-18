import 'dart:collection';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/models/extension.dart';

import '../cubits/score_cubit.dart';
import '../cubits/theme_cubit.dart';
import '../models/age_of_giants.dart';
import '../models/lacour/lacour.dart';
import '../models/land.dart';
import '../models/quests/quest.dart';
import '../models/selection_mode.dart';
import 'castle_tile.dart';
import 'giant_details_widget.dart';
import 'kingdomino_widget.dart';

class BottomBar extends StatefulWidget {
  final Function getSelectionMode;
  final Function setSelectionMode;
  final Function getSelectedLandType;
  final Function setSelectedLandType;
  final Function getSelectedCourtierType;
  final Function setSelectedCourtierType;
  final Function getExtension;
  final AutoSizeGroup groupScore;
  final HashSet<QuestType> quests;

  const BottomBar(
      {required this.getSelectionMode,
      required this.setSelectionMode,
      required this.getSelectedLandType,
      required this.setSelectedLandType,
      required this.getSelectedCourtierType,
      required this.setSelectedCourtierType,
      required this.getExtension,
      required this.quests,
      required this.groupScore,
      Key? key})
      : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  _BottomBarState();

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
      const VerticalDivider(),
      landButton(null),
      const VerticalDivider(),
      castleButton(),
      const VerticalDivider(),
      crownButton(),
    ];

    if (widget.getExtension() == Extension.ageOfGiants) {
      kingdomEditorWidgets.add(giantButton());
    } else if (widget.getExtension() == Extension.laCour) {
      kingdomEditorWidgets.add(resourceButton());

      for (var element in CourtierType.values) {
        kingdomEditorWidgets.add(courtierButton(element));
      }
    }

    return Wrap(
      alignment: WrapAlignment.center,
      children: kingdomEditorWidgets,
    );
  }

  final Border _selectedBorder = Border(
    right: BorderSide(width: 1.5, color: Colors.red.shade600),
    top: BorderSide(width: 1.5, color: Colors.red.shade600),
    left: BorderSide(width: 1.5, color: Colors.red.shade600),
    bottom: BorderSide(width: 1.5, color: Colors.red.shade900),
  );

  Widget landButton(LandType? landType) {
    var isSelected = widget.getSelectionMode() == SelectionMode.land &&
        widget.getSelectedLandType() == landType;

    return GestureDetector(
        onTap: () => _onSelectLandType(landType),
        child: Container(
            margin: const EdgeInsets.all(5.0),
            height: _buttonSize,
            width: _buttonSize,
            decoration: BoxDecoration(
                border: isSelected
                    ? _selectedBorder
                    : landType == null
                        ? null
                        : outline),
            child: Container(
              color: getColorForLandType(landType),
              child: null,
            )));
  }

  Widget resourceButton() {
    var isSelected = widget.getSelectionMode() == SelectionMode.resource;

    return GestureDetector(
        onTap: () => widget.setSelectionMode(SelectionMode.resource),
        child: Container(
            margin: const EdgeInsets.all(5.0),
            height: _buttonSize,
            width: _buttonSize,
            decoration:
                BoxDecoration(border: isSelected ? _selectedBorder : null),
            child: Image.asset('assets/lacour/resource.png')));
  }

  Widget courtierButton(CourtierType courtierType) {
    var isSelected = widget.getSelectionMode() == SelectionMode.courtier &&
        widget.getSelectedCourtierType() == courtierType;

    return GestureDetector(
        onTap: () => _onSelectCourtierType(courtierType),
        child: Container(
            margin: const EdgeInsets.all(5.0),
            height: _buttonSize,
            width: _buttonSize,
            decoration:
                BoxDecoration(border: isSelected ? _selectedBorder : null),
            child: Image(
                height: 50,
                width: 50,
                image: AssetImage(courtierPicture[courtierType]!))));
  }

  Widget castleButton() {
    bool isSelected = widget.getSelectionMode() == SelectionMode.castle &&
        widget.getSelectedLandType() == LandType.castle;

    return GestureDetector(
      onTap: () => setState(() {
        widget.setSelectionMode(SelectionMode.castle);
        widget.setSelectedLandType(LandType.castle);
      }),
      child: Container(
        margin: const EdgeInsets.all(5.0),
        height: _buttonSize,
        width: _buttonSize,
        decoration: BoxDecoration(
            color: Colors.white,
            border: isSelected ? _selectedBorder : outline),
        child: CastleTile(context.read<ThemeCubit>().state),
      ),
    );
  }

  Widget crownButton() {
    var isSelected = widget.getSelectionMode() == SelectionMode.crown;

    return GestureDetector(
        onTap: () => _onSelectCrown(),
        child: Container(
          margin: const EdgeInsets.all(5.0),
          height: _buttonSize,
          width: _buttonSize,
          decoration:
              BoxDecoration(border: isSelected ? _selectedBorder : null),
          child: const FittedBox(fit: BoxFit.fitHeight, child: Text(crown)),
        ));
  }

  Widget giantButton() {
    var isSelected = widget.getSelectionMode() == SelectionMode.giant;

    return GestureDetector(
        onTap: () => _onSelectGiant(),
        /*onLongPress: () => showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  content: GiantsDetailsWidget(
                      scoreOfQuest:
                          context.read<ScoreCubit>().state.scoreOfQuest,
                      quests: widget.quests,
                      groupScore: widget.groupScore,
                      score: context.read<ScoreCubit>().state.score),
                  actions: <Widget>[
                    TextButton(
                      child: const Icon(
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
            ),*/
        child: Container(
          margin: const EdgeInsets.all(5.0),
          height: _buttonSize,
          width: _buttonSize,
          decoration:
              BoxDecoration(border: isSelected ? _selectedBorder : null),
          child: const FittedBox(fit: BoxFit.fitHeight, child: Text(giant)),
        ));
  }

  //CALLBACKS
  void _onSelectLandType(LandType? selectedType) {
    if (selectedType == LandType.castle) {
      _onSelectCastle();
    } else {
      setState(() {
        widget.setSelectedLandType(selectedType);
        widget.setSelectionMode(SelectionMode.land);
      });
    }
  }

  void _onSelectCourtierType(CourtierType selectedType) {
    setState(() {
      widget.setSelectedCourtierType(selectedType);
      widget.setSelectionMode(SelectionMode.courtier);
    });
  }

  void _onSelectCrown() {
    setState(() {
      widget.setSelectionMode(SelectionMode.crown);
    });
  }

  void _onSelectCastle() {
    setState(() {
      widget.setSelectedLandType(LandType.castle);
      widget.setSelectionMode(SelectionMode.castle);
    });
  }

  void _onSelectGiant() {
    setState(() {
      widget.setSelectionMode(SelectionMode.giant);
    });
  }
}
