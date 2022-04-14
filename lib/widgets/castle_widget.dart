import 'package:flutter/material.dart';
import 'kingdomino_score_widget.dart';

class CastleWidget extends StatelessWidget {
  final Color kingColor;

  CastleWidget(this.kingColor);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: kingColor,
        child: FittedBox(fit: BoxFit.fitWidth, child: Text(castle)));
  }
}
