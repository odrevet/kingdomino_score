import 'package:flutter/material.dart';

class CardboardTile extends StatelessWidget {
  final Widget? child;

  const CardboardTile({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: 3.0, color: Colors.blueGrey.shade600),
          bottom: BorderSide(width: 3.0, color: Colors.blueGrey.shade900),
        ),
      ),
      child: child,
    );
  }
}
