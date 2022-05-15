import 'dart:collection';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/models/extensions/extension.dart';
import 'package:kingdomino_score_count/widgets/land_tile.dart';

import '../cubits/theme_cubit.dart';
import '../models/extensions/age_of_giants.dart';
import '../models/extensions/lacour/lacour.dart';
import '../models/land.dart';
import '../models/quests/quest.dart';
import '../models/selection_mode.dart';
import 'castle_tile.dart';
import 'kingdomino_widget.dart';

class BottomBar extends StatefulWidget {
  final Function getSelectionMode;
  final Function setSelectionMode;
  final Function getSelectedLandType;
  final Function setSelectedLandType;
  final Function getSelectedcourtier;
  final Function setSelectedcourtier;
  final Function getExtension;
  final AutoSizeGroup groupScore;
  final HashSet<QuestType> quests;

  const BottomBar(
      {required this.getSelectionMode,
      required this.setSelectionMode,
      required this.getSelectedLandType,
      required this.setSelectedLandType,
      required this.getSelectedcourtier,
      required this.setSelectedcourtier,
      required this.getExtension,
      required this.quests,
      required this.groupScore,
      Key? key})
      : super(key: key);

  @override
  BottomBarState createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  BottomBarState();

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

      for (var element in [
        Farmer(),
        Banker(),
        AxeWarrior(),
        Captain(),
        Fisherman(),
        HeavyArchery(),
        King(),
        LightArchery(),
        Lumberjack(),
        Queen(),
        Shepherdess(),
        SwordWarrior()
      ]) {
        kingdomEditorWidgets.add(courtierButton(element));
      }
    }

    return Wrap(
      alignment: WrapAlignment.center,
      children: kingdomEditorWidgets,
    );
  }

  final BoxShadow _selectedBoxShadow = const BoxShadow(
    color: Colors.yellowAccent,
    spreadRadius: 5,
    blurRadius: 3,
  );

  Widget landButton(LandType? landType) {
    var isSelected = widget.getSelectionMode() == SelectionMode.land &&
        widget.getSelectedLandType() == landType;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
          onTap: () => _onSelectLandType(landType),
          child: Container(
              margin: const EdgeInsets.all(5.0),
              height: _buttonSize,
              width: _buttonSize,
              decoration: BoxDecoration(
                  boxShadow: isSelected ? [_selectedBoxShadow] : null),
              child: LandTile(landType: landType))),
    );
  }

  Widget resourceButton() {
    var isSelected = widget.getSelectionMode() == SelectionMode.resource;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
          onTap: () => widget.setSelectionMode(SelectionMode.resource),
          child: Container(
              margin: const EdgeInsets.all(5.0),
              height: _buttonSize,
              width: _buttonSize,
              decoration: BoxDecoration(
                  boxShadow: isSelected ? [_selectedBoxShadow] : null),
              child: Image.asset('assets/lacour/resource.png'))),
    );
  }

  Widget courtierButton(Courtier courtier) {
    var isSelected = widget.getSelectionMode() == SelectionMode.courtier &&
        widget.getSelectedcourtier() == courtier;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
          onTap: () => _onSelectcourtier(courtier),
          child: Container(
              margin: const EdgeInsets.all(5.0),
              height: _buttonSize,
              width: _buttonSize,
              decoration: BoxDecoration(
                  boxShadow: isSelected ? [_selectedBoxShadow] : null),
              child: Image(
                  height: 50,
                  width: 50,
                  image: AssetImage(courtierPicture[courtier.runtimeType]!)))),
    );
  }

  Widget castleButton() {
    bool isSelected = widget.getSelectionMode() == SelectionMode.castle &&
        widget.getSelectedLandType() == LandType.castle;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => setState(() {
          widget.setSelectionMode(SelectionMode.castle);
          widget.setSelectedLandType(LandType.castle);
        }),
        child: Container(
          margin: const EdgeInsets.all(5.0),
          height: _buttonSize,
          width: _buttonSize,
          decoration: BoxDecoration(
              boxShadow: isSelected ? [_selectedBoxShadow] : null,
              border: outline),
          child: CastleTile(context.read<ThemeCubit>().state),
        ),
      ),
    );
  }

  Widget crownButton() {
    var isSelected = widget.getSelectionMode() == SelectionMode.crown;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
          onTap: () => _onSelectCrown(),
          child: Container(
            margin: const EdgeInsets.all(5.0),
            height: _buttonSize,
            width: _buttonSize,
            decoration: BoxDecoration(
                boxShadow: isSelected ? [_selectedBoxShadow] : null),
            child: const FittedBox(fit: BoxFit.fitHeight, child: Text(crown)),
          )),
    );
  }

  Widget giantButton() {
    var isSelected = widget.getSelectionMode() == SelectionMode.giant;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
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
            decoration: BoxDecoration(
                boxShadow: isSelected ? [_selectedBoxShadow] : null),
            child: const FittedBox(fit: BoxFit.fitHeight, child: Text(giant)),
          )),
    );
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

  void _onSelectcourtier(Courtier courtier) {
    setState(() {
      widget.setSelectedcourtier(courtier);
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
