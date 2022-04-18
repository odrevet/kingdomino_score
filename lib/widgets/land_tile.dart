import 'package:flutter/material.dart';

import '../models/land.dart';

class LandTile extends StatelessWidget {
  final LandType? landType;
  final Widget? child;

  const LandTile({required this.landType, this.child, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: getColorForLandType(landType),
      child: child,
    );
  }
}
