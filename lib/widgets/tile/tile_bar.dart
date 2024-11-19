import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/cubits/rules_cubit.dart';
import 'package:kingdomino_score_count/cubits/user_selection_cubit.dart';
import 'package:kingdomino_score_count/models/extensions/extension.dart';
import 'package:kingdomino_score_count/widgets/tile/land_tile.dart';

import '../../cubits/theme_cubit.dart';
import '../../models/extensions/age_of_giants.dart';
import '../../models/extensions/lacour/lacour.dart';
import '../../models/land.dart';
import '../../models/user_selection.dart';
import '../highlight_box.dart';
import '../kingdomino_widget.dart';
import 'castle_tile.dart';

class TileBar extends StatefulWidget {
  final bool verticalAlign;

  const TileBar({required this.verticalAlign, super.key});

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
      landButton(LandType.wheat),
      landButton(LandType.grassland),
      landButton(LandType.forest),
      landButton(LandType.lake),
      landButton(LandType.swamp),
      landButton(LandType.mine),
      widget.verticalAlign ? const Divider() : const VerticalDivider(),
      landButton(LandType.empty),
      widget.verticalAlign ? const Divider() : const VerticalDivider(),
      castleButton(),
      crownButton(),
    ];

    if (context.read<RulesCubit>().state.extension == Extension.ageOfGiants) {
      kingdomEditorWidgets.add(giantButton());
    } else if (context.read<RulesCubit>().state.extension == Extension.laCour) {
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

    return Align(
      alignment: Alignment.center,
      child: Wrap(
        direction: widget.verticalAlign ? Axis.vertical : Axis.horizontal,
        alignment: WrapAlignment.center,
        children: kingdomEditorWidgets,
      ),
    );
  }

  Widget landButton(LandType landType) {
    var isSelected =
        context.read<UserSelectionCubit>().state.getSelectionMode() ==
                SelectionMode.land &&
            context.read<UserSelectionCubit>().state.getSelectedLandType() ==
                landType;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
          onTap: () => _onSelectLandType(landType),
          child: Container(
              margin: const EdgeInsets.all(5.0),
              height: _buttonSize,
              width: _buttonSize,
              decoration: BoxDecoration(
                  boxShadow: isSelected
                      ? [highlightBox(context.read<ThemeCubit>().state)]
                      : null),
              child: LandTile(landType: landType))),
    );
  }

  Widget resourceButton() {
    var isSelected =
        context.read<UserSelectionCubit>().state.getSelectionMode() ==
            SelectionMode.resource;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
          onTap: () => context
              .read<UserSelectionCubit>()
              .state
              .setSelectionMode(SelectionMode.resource),
          child: Container(
              margin: const EdgeInsets.all(5.0),
              height: _buttonSize,
              width: _buttonSize,
              decoration: BoxDecoration(
                  boxShadow: isSelected
                      ? [highlightBox(context.read<ThemeCubit>().state)]
                      : null),
              child: Image.asset('assets/lacour/resource.png'))),
    );
  }

  Widget courtierButton(Courtier courtier) {
    var isSelected = context
                .read<UserSelectionCubit>()
                .state
                .getSelectionMode() ==
            SelectionMode.courtier &&
        context.read<UserSelectionCubit>().state.selectedCourtier == courtier;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
          onTap: () => _onSelectcourtier(courtier),
          child: Container(
              margin: const EdgeInsets.all(5.0),
              height: _buttonSize,
              width: _buttonSize,
              decoration: BoxDecoration(
                  boxShadow: isSelected
                      ? [highlightBox(context.read<ThemeCubit>().state)]
                      : null),
              child: Image(
                  height: 50,
                  width: 50,
                  image: AssetImage(courtierPicture[courtier.runtimeType]!)))),
    );
  }

  Widget castleButton() {
    return BlocBuilder<UserSelectionCubit, UserSelection>(
        builder: (BuildContext context, userSelection) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            userSelection.setSelectionMode(SelectionMode.castle);
            userSelection.setSelectedLandType(LandType.castle);
          },
          child: Container(
            margin: const EdgeInsets.all(5.0),
            height: _buttonSize,
            width: _buttonSize,
            decoration: BoxDecoration(
              boxShadow:
                  userSelection.getSelectionMode() == SelectionMode.castle &&
                          userSelection.getSelectedLandType() == LandType.castle
                      ? [highlightBox(context.read<ThemeCubit>().state)]
                      : null,
            ),
            child: CastleTile(context.read<ThemeCubit>().state),
          ),
        ),
      );
    });
  }

  Widget crownButton() {
    var isSelected =
        context.read<UserSelectionCubit>().state.getSelectionMode() ==
            SelectionMode.crown;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
          onTap: () => _onSelectCrown(),
          child: Container(
            margin: const EdgeInsets.all(5.0),
            height: _buttonSize,
            width: _buttonSize,
            decoration: BoxDecoration(
                boxShadow: isSelected
                    ? [highlightBox(context.read<ThemeCubit>().state)]
                    : null),
            child: const FittedBox(fit: BoxFit.fitHeight, child: Text(crown)),
          )),
    );
  }

  Widget giantButton() {
    var isSelected =
        context.read<UserSelectionCubit>().state.getSelectionMode() ==
            SelectionMode.giant;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
          onTap: () => _onSelectGiant(),
          child: Container(
            margin: const EdgeInsets.all(5.0),
            height: _buttonSize,
            width: _buttonSize,
            decoration: BoxDecoration(
                boxShadow: isSelected
                    ? [highlightBox(context.read<ThemeCubit>().state)]
                    : null),
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
