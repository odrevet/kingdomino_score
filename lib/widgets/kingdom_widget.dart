import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingdomino_score_count/cubits/theme_cubit.dart';

import '../cubits/kingdom_cubit.dart';
import '../models/age_of_giants.dart';
import '../models/kingdom.dart';
import '../models/lacour/lacour.dart';
import '../models/land.dart';
import '../models/selectionMode.dart';
import 'castle_widget.dart';
import 'kingdomino_widget.dart';

class KingdomWidget extends StatefulWidget {
  const KingdomWidget(
      {required Function this.getSelectionMode,
      required Function this.getSelectedLandType,
      required Function this.getSelectedCourtierType,
      required Function this.getGameSet,
      required Function this.calculateScore,
      required Kingdom this.kingdom});

  final getSelectionMode;
  final getSelectedLandType;
  final getSelectedCourtierType;
  final getGameSet;
  final calculateScore;
  final kingdom;

  @override
  _KingdomWidgetState createState() => _KingdomWidgetState();
}

class _KingdomWidgetState extends State<KingdomWidget> {
  _KingdomWidgetState();

  Widget _buildLand(int y, int x) {
    Land? land = widget.kingdom.getLand(x, y);

    if (land == null) {
      return Container(
        child: Text('ERROR $x $y'),
      );
    }

    Widget? child;
    if (land.landType == LandType.castle) {
      child = CastleWidget(context.read<ThemeCubit>().state);
    } else if (land.courtierType != null) {
      child = Container(
        padding: const EdgeInsets.all(10.0),
        decoration: new BoxDecoration(
          color: getColorForLandType(land.landType),
        ),
        child: Image(image: AssetImage(courtierPicture[land.courtierType]!)),
      );
    } else {
      if (land.crowns > 0) {
        String text = (crown * land.crowns);
        text += giant * land.giants;
        child = Container(
          color: getColorForLandType(land.landType),
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Text(text,
                style: TextStyle(fontSize: constraints.maxWidth / 4));
          }),
        );
      } else if (land.hasResource) {
        child = Container(
          color: getColorForLandType(land.landType),
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Align(
                child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Text(getResourceForLandType(land.landType),
                  style: TextStyle(
                      fontSize: constraints.maxWidth / 2,
                      color: getResourceColorForLandType(land.landType))),
            ));
          }),
        );
      } else {
        child = Container(
          color: getColorForLandType(land.landType),
        );
      }
    }

    return Container(
        child: child,
        decoration: BoxDecoration(
            border: land.landType == null
                ? Border.all(
                    width: 0.5,
                    color: Colors.blueGrey.shade900,
                  )
                : Border(
                    right:
                        BorderSide(width: 2.5, color: Colors.blueGrey.shade600),
                    bottom:
                        BorderSide(width: 2.5, color: Colors.blueGrey.shade900),
                  )));
  }

  Widget _buildLands(BuildContext context, int index) {
    var kingdom = context.read<KingdomCubit>().state;
    int gridStateLength = kingdom.getLands().length;

    int x, y = 0;
    x = (index / gridStateLength).floor();
    y = (index % gridStateLength);
    return GestureDetector(
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
              widget.getSelectedCourtierType);
          widget.calculateScore(context.read<KingdomCubit>().state);
        }
      },
      child: GridTile(
        child: Container(
          child: _buildLand(y, x),
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
