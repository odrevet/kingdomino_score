import 'package:flutter/material.dart';

import '../models/land.dart';

class LandTile extends StatelessWidget {
  final LandType? landType;
  final Widget? child;

  const LandTile({required this.landType, this.child, super.key});

  @override
  Widget build(BuildContext context) {
    if (landType == null) {
      return Container(
        color: Theme.of(context).primaryColor,
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
        child: Container(
          decoration: BoxDecoration(
              border: Border(
            right: BorderSide(width: 3.0, color: Colors.blueGrey.shade600),
            bottom: BorderSide(width: 3.0, color: Colors.blueGrey.shade900),
          )),
          child: child,
        ),
      );
    }
  }
}
