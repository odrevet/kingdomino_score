import 'package:flutter/material.dart';

import '../../models/land.dart';
import 'cardboard_tile.dart';

class LandTile extends StatelessWidget {
  final LandType? landType;
  final Widget? child;

  const LandTile({required this.landType, this.child, super.key});

  @override
  Widget build(BuildContext context) {
    if (landType == null) {
      return Container(
        color: Colors.transparent.withOpacity(0.6),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
            width: 0.5,
            color: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          )),
          child: child,
        ),
      );
    } else {
      return Container(
        color: getColorForLandType(landType),
        child: CardboardTile(key: null, child: child),
      );
    }
  }
}
