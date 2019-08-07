import 'package:flutter/material.dart';

import 'main.dart';
import 'kingdom.dart';
import 'ageOfGiants.dart';

class KingdomWidget extends StatefulWidget {
  final MainWidgetState _mainWidgetState;

  KingdomWidget(this._mainWidgetState);

  @override
  _KingdomWidgetState createState() =>
      _KingdomWidgetState(this._mainWidgetState);
}

class _KingdomWidgetState extends State<KingdomWidget> {
  MainWidgetState _mainWidgetState;

  _KingdomWidgetState(this._mainWidgetState);

  void _onLandTap(int x, int y) {
    Land land = _mainWidgetState.kingdom.getLand(x, y);
    setState(() {
      switch (_mainWidgetState.selectionMode) {
        case SelectionMode.land:
          land.landType = _mainWidgetState.selectedLandType;
          land.reset();
          break;
        case SelectionMode.crown:
          if (land.landType == LandType.castle ||
              land.landType == LandType.none) break;
          land.crowns++;
          if (land.crowns >
              _mainWidgetState.getGameSet()[land.landType]['crowns']['max']) {
            land.reset();
          }
          break;
        case SelectionMode.castle:
          //remove previous castle if any
          for (var cx = 0; cx < _mainWidgetState.kingdom.size; cx++) {
            for (var cy = 0; cy < _mainWidgetState.kingdom.size; cy++) {
              if (_mainWidgetState.kingdom.getLand(cx, cy).landType ==
                  LandType.castle) {
                _mainWidgetState.kingdom.getLand(cx, cy).landType =
                    LandType.none;
                _mainWidgetState.kingdom.getLand(cx, cy).crowns = 0;
              }
            }
          }

          land.landType = _mainWidgetState.selectedLandType; //should be castle
          land.reset();
          break;
        case SelectionMode.giant:
          if (land.crowns > 0) land.hasGiant = !land.hasGiant;
          break;
      }
    });

    _mainWidgetState.clearWarnings();
    _mainWidgetState.checkKingdom();
    _mainWidgetState.updateScores();
  }

  Widget _buildLand(int x, int y) {
    Land land = _mainWidgetState.kingdom.getLand(x, y);
    Color color = getColorForLandType(land.landType, context);
    if (land.landType == LandType.castle)
      return Container(
          color: color,
          child: FittedBox(fit: BoxFit.fitWidth, child: Text(castle)));
    else {
      String text = crown * land.crowns;
      if (land.hasGiant) text += giant;
      return Container(
        color: color,
        child: new LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Text(text,
              style: TextStyle(fontSize: constraints.maxWidth / 3));
        }),
      );
    }
  }

  Widget _buildLands(BuildContext context, int index) {
    int gridStateLength = _mainWidgetState.kingdom.getLands().length;
    int x, y = 0;
    x = (index / gridStateLength).floor();
    y = (index % gridStateLength);
    return GestureDetector(
      onTap: () => _onLandTap(x, y),
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 0.5)),
          child: _buildLand(x, y),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int gridStateLength = _mainWidgetState.kingdom.getLands().length;
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            border: Border(
          right: BorderSide(width: 3.5, color: Colors.blueGrey.shade600),
          bottom: BorderSide(width: 3.5, color: Colors.blueGrey.shade900),
        )),
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

Color getColorForLandType(LandType type, [BuildContext context]) {
  Color color;
  switch (type) {
    case LandType.none:
      color = context == null ? Colors.black : Theme.of(context).canvasColor;
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
      color = Colors.blue;
      break;
    case LandType.mine:
      color = Colors.brown.shade800;
      break;
    case LandType.swamp:
      color = Colors.grey;
      break;
    case LandType.castle:
      color = Colors.white;
      break;
    default:
      color = context == null ? Colors.black : Theme.of(context).canvasColor;
  }

  return color;
}
