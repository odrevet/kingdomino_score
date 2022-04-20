import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/cubits/theme_cubit.dart';

import '../cubits/kingdom_cubit.dart';
import '../models/extensions/age_of_giants.dart';
import '../models/kingdom.dart';
import '../models/extensions/lacour/lacour.dart';
import '../models/land.dart';
import '../models/selection_mode.dart';
import 'castle_tile.dart';
import 'kingdomino_widget.dart';
import 'land_tile.dart';

class KingdomWidget extends StatefulWidget {
  final Function getSelectionMode;
  final Function getSelectedLandType;
  final Function getSelectedcourtier;
  final Function getGameSet;
  final Function calculateScore;
  final Kingdom kingdom;

  const KingdomWidget(
      {required this.getSelectionMode,
      required this.getSelectedLandType,
      required this.getSelectedcourtier,
      required this.getGameSet,
      required this.calculateScore,
      required this.kingdom,
      Key? key})
      : super(key: key);

  @override
  _KingdomWidgetState createState() => _KingdomWidgetState();
}

class _KingdomWidgetState extends State<KingdomWidget> {
  _KingdomWidgetState();

  Widget _buildLand(int y, int x) {
    Land? land = widget.kingdom.getLand(x, y);

    if (land == null) {
      return Text('ERROR $x $y');
    }

    Widget? child;
    if (land.landType == LandType.castle) {
      child = CastleTile(context.read<ThemeCubit>().state);
    } else if (land.courtier != null) {
      child = LandTile(
          landType: land.landType,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image(
                image: AssetImage(courtierPicture[land.courtier.runtimeType]!)),
          ));
    } else {
      if (land.crowns > 0) {
        String text = (crown * land.crowns);
        text += giant * land.giants;
        child = LandTile(
          landType: land.landType,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Text(text,
                style: TextStyle(fontSize: constraints.maxWidth / 4));
          }),
        );
      } else if (land.hasResource) {
        child = LandTile(
          landType: land.landType,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Align(
                child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Text(getResourceForLandType(land.landType),
                  style: TextStyle(fontSize: constraints.maxWidth / 2)),
            ));
          }),
        );
      } else {
        child = LandTile(
          landType: land.landType,
        );
      }
    }

    return child;
  }

  Widget _buildLands(BuildContext context, int index) {
    var kingdom = context.read<KingdomCubit>().state;
    int gridStateLength = kingdom.getLands().length;

    int x, y = 0;
    x = (index / gridStateLength).floor();
    y = (index % gridStateLength);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          var selectionMode = widget.getSelectionMode();
          var selectedLandType = widget.getSelectedLandType();
          if (selectionMode != SelectionMode.land ||
              selectedLandType != kingdom.getLand(x, y)!.landType) {
            context.read<KingdomCubit>().setLand(
                x,
                y,
                selectedLandType,
                widget.getSelectionMode,
                widget.getGameSet,
                widget.getSelectedcourtier);
            widget.calculateScore(context.read<KingdomCubit>().state);
          }
        },
        child: GridTile(
          child: Container(
            child: _buildLand(y, x),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int gridStateLength = widget.kingdom.getLands().length;
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridStateLength,
          ),
          itemBuilder: _buildLands,
          itemCount: gridStateLength * gridStateLength,
        ),
      ),
    );
  }
}
