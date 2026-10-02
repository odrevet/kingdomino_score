import 'package:flutter/material.dart';
import 'package:kingdomino_score_count/models/quests/quest.dart';

class AlignmentStrikesPainter extends CustomPainter {
  final List<CrownAlignment> alignments;
  final double cell;

  const AlignmentStrikesPainter({
    required this.alignments,
    required this.cell,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final outline = Paint()
      ..color = Colors.white
      ..strokeWidth = cell / 10 + 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final line = Paint()
      ..color = Colors.red
      ..strokeWidth = cell / 10
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (final alignment in alignments) {
      final start = Offset(
        (alignment.x0 + 0.5) * cell,
        (alignment.y0 + 0.5) * cell,
      );
      final end = Offset(
        (alignment.x2 + 0.5) * cell,
        (alignment.y2 + 0.5) * cell,
      );
      canvas.drawLine(start, end, outline);
      canvas.drawLine(start, end, line);
    }
  }

  @override
  bool shouldRepaint(covariant AlignmentStrikesPainter oldDelegate) => true;
}