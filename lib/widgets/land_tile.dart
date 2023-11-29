import 'package:flutter/material.dart';

import '../models/land.dart';

class LandTile extends StatelessWidget {
  final LandType? landType;
  final Widget? child;

  const LandTile({required this.landType, this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: getColorForLandType(landType),
      child: Container(
        decoration: BoxDecoration(
            border: landType == null
                ? Border.all(
                    width: 0.0,
                    color: Colors.blueGrey.shade900,
                  )
                : Border(
                    right:
                        BorderSide(width: 3.0, color: Colors.blueGrey.shade600),
                    bottom:
                        BorderSide(width: 3.0, color: Colors.blueGrey.shade900),
                  )),
        child: child,
      ),
    );
  }
}
