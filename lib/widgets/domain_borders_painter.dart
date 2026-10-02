import 'package:flutter/material.dart';
import 'package:kingdomino_score_count/models/domain.dart';

class DomainBordersPainter extends CustomPainter {
  final List<Domain> domains;
  final int n;
  final double cell;

  const DomainBordersPainter({
    required this.domains,
    required this.n,
    required this.cell,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final under = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final over = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (final domain in domains) {
      for (final key in domain.cells) {
        final r = key ~/ n;
        final c = key % n;
        final left = c * cell;
        final top = r * cell;
        final right = (c + 1) * cell;
        final bottom = (r + 1) * cell;

        if (!domain.contains(r - 1, c)) {
          _edge(canvas, Offset(left, top), Offset(right, top), under, over);
        }
        if (!domain.contains(r + 1, c)) {
          _edge(
            canvas,
            Offset(left, bottom),
            Offset(right, bottom),
            under,
            over,
          );
        }
        if (!domain.contains(r, c - 1)) {
          _edge(canvas, Offset(left, top), Offset(left, bottom), under, over);
        }
        if (!domain.contains(r, c + 1)) {
          _edge(
            canvas,
            Offset(right, top),
            Offset(right, bottom),
            under,
            over,
          );
        }
      }
    }
  }

  void _edge(Canvas canvas, Offset a, Offset b, Paint under, Paint over) {
    canvas.drawLine(a, b, under);
    final length = (b - a).distance;
    if (length == 0) return;
    final direction = (b - a) / length;
    const dash = 4.0;
    const gap = 4.0;
    for (var d = 0.0; d < length; d += dash + gap) {
      final end = d + dash > length ? length : d + dash;
      canvas.drawLine(a + direction * d, a + direction * end, over);
    }
  }

  @override
  bool shouldRepaint(covariant DomainBordersPainter oldDelegate) => true;
}