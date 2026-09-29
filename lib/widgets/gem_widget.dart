import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:kingdomino_score_count/models/extensions/lost_treasures/lost_treasures.dart';

class _DiamondClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(0, size.height / 2)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _DiamondBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(0, size.height / 2)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = Colors.black,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GemWidget extends StatelessWidget {
  static const double _scale = 1.12;
  static const double _edgeOffset = 0.3;

  final Gem gem;
  final int orientation;
  final double size;

  const GemWidget({
    required this.gem,
    required this.orientation,
    required this.size,
    super.key,
  });

  String _symbol(GemQuarter quarter) {
    if (quarter.isSkull) {
      return '💀';
    }
    if (quarter.crowns > 0) {
      return '👑' * quarter.crowns;
    }
    return '';
  }

  Widget _cell() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: gem.color.color,
          border: Border.all(color: Colors.black, width: 0.5),
        ),
      ),
    );
  }

  Widget _symbolOnEdge(
      GemQuarter quarter,
      double cx,
      double cy,
      double angle,
      ) {
    final symbol = _symbol(quarter);
    if (symbol.isEmpty) {
      return const SizedBox.shrink();
    }
    final w = size * 0.5;
    final h = size * 0.2;
    return Positioned(
      left: size * cx - w / 2,
      top: size * cy - h / 2,
      width: w,
      height: h,
      child: Transform.rotate(
        angle: angle,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(symbol, maxLines: 1, style: TextStyle(fontSize: size * 0.16)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const c = _edgeOffset;
    const quarterTurn = math.pi / 4;
    return Transform.rotate(
      angle: orientation * math.pi / 2,
      child: Transform.scale(
        scale: _scale,
        child: SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            foregroundPainter: _DiamondBorderPainter(),
            child: ClipPath(
              clipper: _DiamondClipper(),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(child: Row(children: [_cell(), _cell()])),
                      Expanded(child: Row(children: [_cell(), _cell()])),
                    ],
                  ),
                  _symbolOnEdge(gem.topLeft, c, c, -quarterTurn),
                  _symbolOnEdge(gem.topRight, 1 - c, c, quarterTurn),
                  _symbolOnEdge(gem.bottomLeft, c, 1 - c, quarterTurn),
                  _symbolOnEdge(gem.bottomRight, 1 - c, 1 - c, -quarterTurn),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}