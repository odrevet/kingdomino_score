import 'package:flutter/material.dart';

import 'kingdomino_widget.dart';

class CastleWidget extends StatelessWidget {
  final Color kingColor;

  const CastleWidget(this.kingColor, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: kingColor,
        child: const FittedBox(fit: BoxFit.fitWidth, child: Text(castle)));
  }
}
