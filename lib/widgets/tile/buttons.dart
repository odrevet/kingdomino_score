import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/cubits/user_selection_cubit.dart';
import 'package:kingdomino_score_count/widgets/tile/land_tile.dart';

import '../../cubits/theme_cubit.dart';
import '../../models/extensions/age_of_giants.dart';
import '../../models/extensions/lacour/lacour.dart';
import '../../models/land.dart';
import '../../models/user_selection.dart';
import '../highlight_box.dart';
import '../kingdomino_widget.dart';
import 'castle_tile.dart';

class LandButton extends StatelessWidget {
  final LandType landType;
  final double buttonSize;
  final Function(LandType) onSelectLandType;

  const LandButton({
    Key? key,
    required this.landType,
    required this.buttonSize,
    required this.onSelectLandType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isSelected =
        context.read<UserSelectionCubit>().state.getSelectionMode() ==
                SelectionMode.land &&
            context.read<UserSelectionCubit>().state.getSelectedLandType() ==
                landType;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onSelectLandType(landType),
        child: Container(
          margin: const EdgeInsets.all(5.0),
          height: buttonSize,
          width: buttonSize,
          decoration: BoxDecoration(
            boxShadow: isSelected
                ? [highlightBox(context.read<ThemeCubit>().state)]
                : null,
          ),
          child: LandTile(landType: landType),
        ),
      ),
    );
  }
}

class ResourceButton extends StatelessWidget {
  final double buttonSize;

  const ResourceButton({
    Key? key,
    required this.buttonSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserSelectionCubit, UserSelection>(
        builder: (BuildContext context, userSelection) {
      var isSelected =
          userSelection.getSelectionMode() == SelectionMode.resource;

      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => context
              .read<UserSelectionCubit>()
              .setSelectionMode(SelectionMode.resource),
          child: Container(
            margin: const EdgeInsets.all(5.0),
            height: buttonSize,
            width: buttonSize,
            decoration: BoxDecoration(
              boxShadow: isSelected
                  ? [highlightBox(context.read<ThemeCubit>().state)]
                  : null,
            ),
            child: Image.asset('assets/lacour/resource.png'),
          ),
        ),
      );
    });
  }
}

class CourtierButton extends StatelessWidget {
  final Courtier courtier;
  final double buttonSize;
  final Function(Courtier) onSelectCourtier;

  const CourtierButton({
    Key? key,
    required this.courtier,
    required this.buttonSize,
    required this.onSelectCourtier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isSelected = context
                .read<UserSelectionCubit>()
                .state
                .getSelectionMode() ==
            SelectionMode.courtier &&
        context.read<UserSelectionCubit>().state.selectedCourtier == courtier;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onSelectCourtier(courtier),
        child: Container(
          margin: const EdgeInsets.all(5.0),
          height: buttonSize,
          width: buttonSize,
          decoration: BoxDecoration(
            boxShadow: isSelected
                ? [highlightBox(context.read<ThemeCubit>().state)]
                : null,
          ),
          child: Image(
            height: 50,
            width: 50,
            image: AssetImage(courtierPicture[courtier.runtimeType]!),
          ),
        ),
      ),
    );
  }
}

class CastleButton extends StatelessWidget {
  final double buttonSize;

  const CastleButton({
    Key? key,
    required this.buttonSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserSelectionCubit, UserSelection>(
      builder: (BuildContext context, userSelection) {
        var isSelected =
            userSelection.getSelectionMode() == SelectionMode.castle &&
                userSelection.getSelectedLandType() == LandType.castle;

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              context.read<UserSelectionCubit>().updateSelection(
                    SelectionMode.castle,
                    LandType.castle,
                  );
            },
            child: Container(
              margin: const EdgeInsets.all(5.0),
              height: buttonSize,
              width: buttonSize,
              decoration: BoxDecoration(
                boxShadow: isSelected
                    ? [highlightBox(context.read<ThemeCubit>().state)]
                    : null,
              ),
              child: CastleTile(context.read<ThemeCubit>().state),
            ),
          ),
        );
      },
    );
  }
}

class CrownButton extends StatelessWidget {
  final double buttonSize;
  final VoidCallback onSelectCrown;

  const CrownButton({
    super.key,
    required this.buttonSize,
    required this.onSelectCrown,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserSelectionCubit, UserSelection>(
        builder: (BuildContext context, userSelection) {
      var isSelected = userSelection.getSelectionMode() == SelectionMode.crown;

      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onSelectCrown,
          child: Container(
            margin: const EdgeInsets.all(5.0),
            height: buttonSize,
            width: buttonSize,
            decoration: BoxDecoration(
              boxShadow: isSelected
                  ? [highlightBox(context.read<ThemeCubit>().state)]
                  : null,
            ),
            child: const FittedBox(
              fit: BoxFit.fitHeight,
              child: Text(crown),
            ),
          ),
        ),
      );
    });
  }
}

class GiantButton extends StatelessWidget {
  final double buttonSize;
  final VoidCallback onSelectGiant;

  const GiantButton({
    Key? key,
    required this.buttonSize,
    required this.onSelectGiant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isSelected =
        context.read<UserSelectionCubit>().state.getSelectionMode() ==
            SelectionMode.giant;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onSelectGiant,
        child: Container(
          margin: const EdgeInsets.all(5.0),
          height: buttonSize,
          width: buttonSize,
          decoration: BoxDecoration(
            boxShadow: isSelected
                ? [highlightBox(context.read<ThemeCubit>().state)]
                : null,
          ),
          child: const FittedBox(
            fit: BoxFit.fitHeight,
            child: Text(giant),
          ),
        ),
      ),
    );
  }
}
