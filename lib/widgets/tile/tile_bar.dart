import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/cubits/game_cubit.dart';
import 'package:kingdomino_score_count/cubits/user_selection_cubit.dart';
import 'package:kingdomino_score_count/models/extensions/extension.dart';

import '../../models/extensions/lacour/lacour.dart';
import '../../models/land.dart';
import '../../models/user_selection.dart';
import 'buttons.dart';

class TileBar extends StatefulWidget {
  final bool verticalAlign;
  final Extension extension;

  const TileBar({required this.verticalAlign, required this.extension, super.key});

  @override
  State<TileBar> createState() => _TileBarState();
}

class _TileBarState extends State<TileBar> {
  _TileBarState();

  final double _buttonSize = 40.0;

  var outline = Border(
    right: BorderSide(width: 3.5, color: Colors.blueGrey.shade600),
    bottom: BorderSide(width: 3.5, color: Colors.blueGrey.shade900),
  );

  @override
  Widget build(BuildContext context) {
    var kingdomEditorWidgets = [
      LandButton(
          landType: LandType.wheat,
          buttonSize: _buttonSize,
          onSelectLandType: _onSelectLandType),
      LandButton(
          landType: LandType.grassland,
          buttonSize: _buttonSize,
          onSelectLandType: _onSelectLandType),
      LandButton(
          landType: LandType.forest,
          buttonSize: _buttonSize,
          onSelectLandType: _onSelectLandType),
      LandButton(
          landType: LandType.lake,
          buttonSize: _buttonSize,
          onSelectLandType: _onSelectLandType),
      LandButton(
          landType: LandType.swamp,
          buttonSize: _buttonSize,
          onSelectLandType: _onSelectLandType),
      LandButton(
          landType: LandType.mine,
          buttonSize: _buttonSize,
          onSelectLandType: _onSelectLandType),
      widget.verticalAlign ? const Divider() : const VerticalDivider(),
      LandButton(
          landType: LandType.empty,
          buttonSize: _buttonSize,
          onSelectLandType: _onSelectLandType),
      widget.verticalAlign ? const Divider() : const VerticalDivider(),
      CastleButton(
        buttonSize: _buttonSize,
      ),
      CrownButton(buttonSize: _buttonSize, onSelectCrown: _onSelectCrown),
    ];

    if (context.read<GameCubit>().state.extension == Extension.ageOfGiants) {
      kingdomEditorWidgets.add(
          GiantButton(buttonSize: _buttonSize, onSelectGiant: _onSelectGiant));
    } else if (context.read<GameCubit>().state.extension == Extension.laCour) {
      kingdomEditorWidgets.add(ResourceButton(
        buttonSize: _buttonSize,
      ));

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
        kingdomEditorWidgets.add(CourtierButton(
          buttonSize: _buttonSize,
          courtier: element,
          onSelectCourtier: _onSelectcourtier,
        ));
      }
    }

    return Align(
      alignment: Alignment.center,
      child: Wrap(
        direction: widget.verticalAlign ? Axis.vertical : Axis.horizontal,
        alignment: WrapAlignment.center,
        children: kingdomEditorWidgets,
      ),
    );
  }

  //CALLBACKS
  void _onSelectLandType(LandType? selectedType) {
    if (selectedType == LandType.castle) {
      _onSelectCastle();
    } else {
      setState(() {
        context
            .read<UserSelectionCubit>()
            .state
            .setSelectedLandType(selectedType);
        context
            .read<UserSelectionCubit>()
            .state
            .setSelectionMode(SelectionMode.land);
      });
    }
  }

  void _onSelectcourtier(Courtier courtier) {
    setState(() {
      context.read<UserSelectionCubit>().state.setSelectedCourtier(courtier);
      context
          .read<UserSelectionCubit>()
          .state
          .setSelectionMode(SelectionMode.courtier);
    });
  }

  void _onSelectCrown() {
    setState(() {
      context
          .read<UserSelectionCubit>()
          .state
          .setSelectionMode(SelectionMode.crown);
    });
  }

  void _onSelectCastle() {
    setState(() {
      context
          .read<UserSelectionCubit>()
          .state
          .setSelectedLandType(LandType.castle);
      context
          .read<UserSelectionCubit>()
          .state
          .setSelectionMode(SelectionMode.castle);
    });
  }

  void _onSelectGiant() {
    setState(() {
      context
          .read<UserSelectionCubit>()
          .state
          .setSelectionMode(SelectionMode.giant);
    });
  }
}
