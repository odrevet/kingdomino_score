import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:kingdomino_score_count/models/extensions/lost_treasures/lost_treasures.dart';

const Color _pinkGem = Color(0xFFFF5FB8);

List<Offset> _gemPoints(GemColor color) {
  switch (color) {
    case GemColor.red:
      return const [
        Offset(0.5, 0),
        Offset(1, 0.38),
        Offset(0.82, 1),
        Offset(0.18, 1),
        Offset(0, 0.38),
      ];
    case GemColor.yellow:
      return const [
        Offset(0.3, 0),
        Offset(0.7, 0),
        Offset(1, 0.3),
        Offset(1, 0.7),
        Offset(0.7, 1),
        Offset(0.3, 1),
        Offset(0, 0.7),
        Offset(0, 0.3),
      ];
    case GemColor.green:
      return const [
        Offset(0.5, 0.02),
        Offset(1, 0.95),
        Offset(0, 0.95),
      ];
    case GemColor.blue:
      return const [
        Offset(0.5, 0),
        Offset(1, 0.25),
        Offset(1, 0.75),
        Offset(0.5, 1),
        Offset(0, 0.75),
        Offset(0, 0.25),
      ];
    case GemColor.pink:
      return const [
        Offset(0.5, 0),
        Offset(0.85, 0.15),
        Offset(1, 0.5),
        Offset(0.85, 0.85),
        Offset(0.5, 1),
        Offset(0.15, 0.85),
        Offset(0, 0.5),
        Offset(0.15, 0.15),
      ];
    case GemColor.joker:
      return List.generate(10, (i) {
        final angle = -math.pi / 2 + i * math.pi / 5;
        final radius = i.isEven ? 0.5 : 0.22;
        return Offset(
          0.5 + radius * math.cos(angle),
          0.5 + radius * math.sin(angle),
        );
      });
  }
}

class _TokenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFF7B4AA8), Color(0xFF4A2468)],
        ).createShader(rect),
    );
    canvas.drawCircle(
      center,
      radius - 0.5,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = Colors.black54,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GemShapePainter extends CustomPainter {
  final GemColor color;

  const _GemShapePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final points = _gemPoints(color)
        .map((p) => Offset(p.dx * size.width, p.dy * size.height))
        .toList();
    final center = size.center(Offset.zero);
    final inner = points.map((p) => center + (p - center) * 0.55).toList();

    Path polygon(List<Offset> pts) {
      final path = Path()..moveTo(pts.first.dx, pts.first.dy);
      for (final p in pts.skip(1)) {
        path.lineTo(p.dx, p.dy);
      }
      return path..close();
    }

    final outerPath = polygon(points);
    final outerPaint = Paint();
    if (color == GemColor.joker) {
      outerPaint.shader = const SweepGradient(
        center: Alignment.center,
        colors: [
          Colors.red,
          Colors.yellow,
          Colors.green,
          Colors.blue,
          _pinkGem,
          Colors.red,
        ],
      ).createShader(Offset.zero & size);
    } else {
      outerPaint.color = color.color;
    }
    canvas.drawPath(outerPath, outerPaint);

    final facetPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = Colors.white.withValues(alpha: 0.7);
    for (var i = 0; i < points.length; i++) {
      canvas.drawLine(points[i], inner[i], facetPaint);
    }
    canvas.drawPath(
      polygon(inner),
      Paint()..color = Colors.white.withValues(alpha: 0.3),
    );
    canvas.drawPath(polygon(inner), facetPaint);
    canvas.drawPath(
      outerPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..strokeJoin = StrokeJoin.round
        ..color = Colors.white.withValues(alpha: 0.9),
    );
  }

  @override
  bool shouldRepaint(covariant _GemShapePainter oldDelegate) =>
      oldDelegate.color != color;
}

class GemWidget extends StatelessWidget {
  static const double _gemRatio = 0.4;
  static const double _cornerOffset = 0.2;

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

  Widget _symbolAt(GemQuarter quarter, double cx, double cy, double angle) {
    final symbol = _symbol(quarter);
    if (symbol.isEmpty) {
      return const SizedBox.shrink();
    }
    final w = size * 0.32;
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
          child: Text(
            symbol,
            maxLines: 1,
            style: TextStyle(fontSize: size * 0.16),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const c = _cornerOffset;
    final gemSize = size * _gemRatio;
    return Transform.rotate(
      angle: orientation * math.pi / 2,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _TokenPainter())),
            Positioned(
              left: (size - gemSize) / 2,
              top: (size - gemSize) / 2,
              width: gemSize,
              height: gemSize,
              child: CustomPaint(painter: _GemShapePainter(gem.color)),
            ),
            _symbolAt(gem.topLeft, c, c, -math.pi / 4),
            _symbolAt(gem.topRight, 1 - c, c, math.pi / 4),
            _symbolAt(gem.bottomLeft, c, 1 - c, -3 * math.pi / 4),
            _symbolAt(gem.bottomRight, 1 - c, 1 - c, 3 * math.pi / 4),
          ],
        ),
      ),
    );
  }
}