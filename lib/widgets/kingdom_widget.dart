import 'package:flutter/material.dart';

import '../models/age_of_giants.dart';
import '../models/kingdom.dart';
import 'kingdomino_score_widget.dart';

Set<Color> KingColors = Set.from([
  Colors.yellow.shade800,
  Colors.blue.shade800,
  Colors.green.shade800,
  Colors.pink.shade800,
  Colors.brown.shade800 // AoG only
]);

class CastleWidget extends StatelessWidget {
  Color? kingColor;

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
      this.getGameSet,
      this.calculateScore,
      this.kingdom,
      this.getKingColor});

  final getSelectionMode;
  final getSelectedLandType;
  final getGameSet;
  final calculateScore;
  final kingdom;
  final getKingColor;

  @override
  _KingdomWidgetState createState() => _KingdomWidgetState(
      getSelectionMode: this.getSelectionMode,
      getSelectedLandType: this.getSelectedLandType,
      getGameSet: this.getGameSet,
      calculateScore: this.calculateScore,
      kingdom: this.kingdom,
      getKingColor: this.getKingColor);
}

class _KingdomWidgetState extends State<KingdomWidget> {
  final getSelectionMode;
  final getSelectedLandType;
  final getGameSet;
  final calculateScore;
  final kingdom;
  final getKingColor;

  _KingdomWidgetState(
      {this.getSelectionMode,
      this.getSelectedLandType,
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
          if (land!.landType == LandType.castle ||
              land.landType == LandType.none) break;
          land.crowns++;
          if (land.crowns > getGameSet()[land.landType]['crowns']['max']) {
            land.reset();
          }
          break;
        case SelectionMode.castle:
          //remove previous castle if any
          for (var cx = 0; cx < kingdom.size; cx++) {
            for (var cy = 0; cy < kingdom.size; cy++) {
              if (kingdom.getLand(cx, cy).landType == LandType.castle) {
                kingdom.getLand(cx, cy).landType = LandType.none;
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
      }
    });

    calculateScore();
  }

  Widget _buildLand(int y, int x) {
    Land land = kingdom.getLand(x, y);

    Widget child;
    if (land.landType == LandType.castle)
      child = CastleWidget(getKingColor());
    else {
      String text = crown * land.crowns;
      text += giant * land.giants;
      child = Container(
        color: getColorForLandType(land.landType),
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Text(text,
              style: TextStyle(fontSize: constraints.maxWidth / 3));
        }),
      );
    }

    return Container(
        child: child,
        decoration: BoxDecoration(
            border: land.landType == LandType.none
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

Color getColorForLandType(LandType? type) {
  Color color;
  switch (type) {
    case LandType.none:
      color = Colors.blueGrey.shade400;
      break;
    case LandType.wheat:
      color = Colors.yellow.shade600;
      break;
    case LandType.grassland:
      color = Colors.lightGreen;
      break;
    case LandType.forest:
      color = Colors.green.shade800;
      break;
    case LandType.lake:
      color = Colors.blue.shade400;
      break;
    case LandType.mine:
      color = Colors.brown.shade800;
      break;
    case LandType.swamp:
      color = Colors.grey.shade400;
      break;
    case LandType.castle:
      color = Colors.white;
      break;
    default:
      color = Colors.red;
  }

  return color;
}
