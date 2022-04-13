import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../kingdom_cubit.dart';
import '../models/age_of_giants.dart';
import '../models/kingdom.dart';
import '../models/lacour/lacour.dart';
import '../models/land.dart';
import 'kingdomino_score_widget.dart';

class CastleWidget extends StatelessWidget {
  Color kingColor;

  CastleWidget(this.kingColor);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: kingColor,
        child: FittedBox(fit: BoxFit.fitWidth, child: Text(castle)));
  }
}

class KingdomWidget extends StatefulWidget {
  KingdomWidget(
      {required Function this.getSelectionMode,
      required Function this.getSelectedLandType,
      required Function this.getSelectedCourtierType,
      required Function this.getGameSet,
      required Function this.calculateScore,
      required Kingdom this.kingdom,
      required Function this.getKingColor});

  final getSelectionMode;
  final getSelectedLandType;
  final getSelectedCourtierType;
  final getGameSet;
  final calculateScore;
  final kingdom;
  final getKingColor;

  @override
  _KingdomWidgetState createState() => _KingdomWidgetState(
      getSelectionMode: this.getSelectionMode,
      getSelectedLandType: this.getSelectedLandType,
      getSelectedCourtierType: this.getSelectedCourtierType,
      getGameSet: this.getGameSet,
      calculateScore: this.calculateScore,
      getKingColor: this.getKingColor);
}

class _KingdomWidgetState extends State<KingdomWidget> {
  final getSelectionMode;
  final getSelectedLandType;
  final getSelectedCourtierType;
  final getGameSet;
  final calculateScore;
  final getKingColor;

  _KingdomWidgetState(
      {required Function this.getSelectionMode,
      required Function this.getSelectedLandType,
      required Function this.getSelectedCourtierType,
      required Function this.getGameSet,
      required Function this.calculateScore,
      required Function this.getKingColor});

  void _onLandTap(int x, int y) {
    Land? land = widget.kingdom.getLand(x, y);

    setState(() {
      switch (getSelectionMode()) {
        case SelectionMode.land:
          land!.landType = getSelectedLandType();
          land.reset();
          break;
        case SelectionMode.crown:
          if (land!.landType == LandType.castle || land.landType == null) break;
          land.crowns++;
          land.courtierType = null;
          if (land.crowns > getGameSet()[land.landType]['crowns']['max']) {
            land.reset();
          }
          break;
        case SelectionMode.castle:
          //remove other castle, if any
          for (var cx = 0; cx < widget.kingdom.size; cx++) {
            for (var cy = 0; cy < widget.kingdom.size; cy++) {
              if (widget.kingdom.getLand(cx, cy).landType == LandType.castle) {
                widget.kingdom.getLand(cx, cy).landType = null;
                widget.kingdom.getLand(cx, cy).crowns = 0;
              }
            }
          }

          land!.landType = getSelectedLandType(); //should be castle
          land.reset();
          break;
        case SelectionMode.giant:
          land!.giants = (land.giants + 1) % (land.crowns + 1);
          break;
        case SelectionMode.courtier:
          if ([
            LandType.grassland,
            LandType.lake,
            LandType.wheat,
            LandType.forest,
            LandType.mine,
            LandType.swamp
          ].contains(land!.landType)) {
            CourtierType courtierType = getSelectedCourtierType();
            if (land.courtierType == courtierType) {
              land.courtierType = null;
              break;
            }

            //remove same courtier type, if any
            for (var cx = 0; cx < widget.kingdom.size; cx++) {
              for (var cy = 0; cy < widget.kingdom.size; cy++) {
                if (widget.kingdom.getLand(cx, cy).courtierType ==
                    courtierType) {
                  widget.kingdom.getLand(cx, cy).courtierType = null;
                }
              }
            }

            land.reset();
            land.courtierType = courtierType;
          }
          break;
        case SelectionMode.resource:
          if ([
            LandType.grassland,
            LandType.lake,
            LandType.wheat,
            LandType.forest
          ].contains(land!.landType)) {
            land.hasResource = !land.hasResource;
            land.crowns = 0;
          }
          break;
      }
    });

    calculateScore();
  }

  Widget _buildLand(int y, int x) {
    Land? land = widget.kingdom.getLand(x, y);

    if (land == null) {
      return Container(
        child: Text('ERROR $x $y'),
      );
    }

    Widget? child;
    if (land.landType == LandType.castle) {
      child = CastleWidget(getKingColor());
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
                borderRadius: BorderRadius.all(Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
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
    int gridStateLength = widget.kingdom.getLands().length;

    int x, y = 0;
    x = (index / gridStateLength).floor();
    y = (index % gridStateLength);
    return GestureDetector(
      onTap: () => context
          .read<KingdomCubit>()
          .setLand(x, y, getSelectedLandType()), //_onLandTap(x, y),  // WIP
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
