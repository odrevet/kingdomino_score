import 'package:flutter/material.dart';

import '../models/age_of_giants.dart';
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
      {this.getSelectionMode,
      this.getSelectedLandType,
      this.getSelectedCourtierType,
      this.getGameSet,
      this.calculateScore,
      this.kingdom,
      this.getKingColor});

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
      kingdom: this.kingdom,
      getKingColor: this.getKingColor);
}

class _KingdomWidgetState extends State<KingdomWidget> {
  final getSelectionMode;
  final getSelectedLandType;
  final getSelectedCourtierType;
  final getGameSet;
  final calculateScore;
  final kingdom;
  final getKingColor;

  _KingdomWidgetState(
      {this.getSelectionMode,
      this.getSelectedLandType,
      this.getSelectedCourtierType,
      this.getGameSet,
      this.calculateScore,
      this.kingdom,
      this.getKingColor});

  void _onLandTap(int x, int y) {
    Land? land = kingdom.getLand(x, y);

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
          for (var cx = 0; cx < kingdom.size; cx++) {
            for (var cy = 0; cy < kingdom.size; cy++) {
              if (kingdom.getLand(cx, cy).landType == LandType.castle) {
                kingdom.getLand(cx, cy).landType = null;
                kingdom.getLand(cx, cy).crowns = 0;
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
            if(land.courtierType == courtierType){
              land.courtierType = null;
              break;
            }

            //remove same courtier type, if any
            for (var cx = 0; cx < kingdom.size; cx++) {
              for (var cy = 0; cy < kingdom.size; cy++) {
                if (kingdom.getLand(cx, cy).courtierType == courtierType) {
                  kingdom.getLand(cx, cy).courtierType = null;
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
    Land land = kingdom.getLand(x, y);

    Widget? child;
    if (land.landType == LandType.castle) {
      child = CastleWidget(getKingColor());
    } else if (land.courtierType != null) {
      child = Container(
        padding: const EdgeInsets.all(10.0),
        decoration: new BoxDecoration(
            color: getColorForLandType(land.landType),
        ),
        child: Image(
            image: AssetImage(courtierPicture[land.courtierType]!)),
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
                    style: TextStyle(fontSize: constraints.maxWidth / 3));
              }),
        );
      } else if (land.hasResource) {
        child = Container(
          color: getColorForLandType(land.landType),
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Align(
                  child: Text('⬤',
                      style: TextStyle(fontSize: constraints.maxWidth / 2, color: getResourceColorForLandType(land.landType))),
                );
              }),
        );
      }
      else{
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
    int gridStateLength = kingdom.getLands().length;
    int x, y = 0;
    x = (index / gridStateLength).floor();
    y = (index % gridStateLength);
    return GestureDetector(
      onTap: () => _onLandTap(x, y),
      child: GridTile(
        child: Container(
          child: _buildLand(y, x),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int gridStateLength = kingdom.getLands().length;
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
