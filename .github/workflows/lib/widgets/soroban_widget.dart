import 'package:flutter/material.dart';
import '../engines/soroban_engine.dart';

class SorobanWidget extends StatelessWidget {
  final SorobanEngine engine;
  final bool interactive;

  const SorobanWidget({
    super.key,
    required this.engine,
    this.interactive = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: engine,
      builder: (context, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              onTapUp: interactive
                  ? (details) => _handleTap(details.localPosition, constraints)
                  : null,
              child: CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: _SorobanPainter(engine),
              ),
            );
          },
        );
      },
    );
  }

  void _handleTap(Offset pos, BoxConstraints constraints) {
    double rodWidth = constraints.maxWidth / SorobanEngine.rodCount;
    int rodIndex = (pos.dx / rodWidth).floor().clamp(0, SorobanEngine.rodCount - 1);

    double beamY = constraints.maxHeight * 0.30;
    if (pos.dy < beamY) {
      // Area manik atas
      engine.toggleUpperBead(rodIndex);
    } else if (pos.dy > beamY + 12) {
      // Area manik bawah (bagi menjadi 4 zona)
      double lowerHeight = constraints.maxHeight - (beamY + 12);
      double relY = pos.dy - (beamY + 12);
      int beadPos = ((relY / lowerHeight) * 4).floor().clamp(0, 3) + 1;
      engine.tapLowerBead(rodIndex, beadPos);
    }
  }
}

class _SorobanPainter extends CustomPainter {
  final SorobanEngine engine;
  _SorobanPainter(this.engine);

  @override
  void paint(Canvas canvas, Size size) {
    final framePaint = Paint()..color = const Color(0xFF5D4037);
    final rodPaint = Paint()
      ..color = const Color(0xFFD7CCC8)
      ..strokeWidth = 6;
    final beamPaint = Paint()..color = const Color(0xFF3E2723);
    final dotPaint = Paint()..color = Colors.amberAccent;

    // Bingkai luar
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(16)),
      framePaint,
    );

    double padding = 14.0;
    double innerWidth = size.width - padding * 2;
    double innerHeight = size.height - padding * 2;
    double rodSpacing = innerWidth / SorobanEngine.rodCount;
    double beamY = padding + innerHeight * 0.28;

    // Latar belakang dalam
    canvas.drawRect(
      Rect.fromLTWH(padding, padding, innerWidth, innerHeight),
      Paint()..color = const Color(0xFFFFF8E1),
    );

    // Gambar 9 batang dan maniknya
    for (int i = 0; i < SorobanEngine.rodCount; i++) {
      double cx = padding + rodSpacing * (i + 0.5);
      canvas.drawLine(
        Offset(cx, padding),
        Offset(cx, size.height - padding),
        rodPaint,
      );

      final rod = engine.rods[i];
      double beadWidth = rodSpacing * 0.72;
      double beadHeight = innerHeight * 0.11;

      // Manik Atas (Nilai 5)
      double upperY = rod.upperActive
          ? beamY - beadHeight / 2 - 4
          : padding + beadHeight / 2 + 4;
      _drawBead(canvas, Offset(cx, upperY), beadWidth, beadHeight, const Color(0xFFFF7043));

      // 4 Manik Bawah (Nilai 1)
      double lowerStart = beamY + 14;
      double lowerEnd = size.height - padding - 4;
      double slotHeight = (lowerEnd - lowerStart) / 5;

      for (int b = 1; b <= 4; b++) {
        bool isActive = b <= rod.lowerActiveCount;
        double by = isActive
            ? lowerStart + slotHeight * (b - 0.5)
            : lowerStart + slotHeight * (b + 0.5);
        _drawBead(canvas, Offset(cx, by), beadWidth, beadHeight, const Color(0xFF29B6F6));
      }
    }

    // Balok pemisah horizontal
    canvas.drawRect(
      Rect.fromLTWH(padding, beamY, innerWidth, 12),
      beamPaint,
    );

    // Titik penanda satuan (unit dots) pada batang ke-2, ke-5, dan ke-8
    for (int unitIdx in [2, 5, 8]) {
      double cx = padding + rodSpacing * (unitIdx + 0.5);
      canvas.drawCircle(Offset(cx, beamY + 6), 3.5, dotPaint);
    }
  }

  void _drawBead(Canvas canvas, Offset center, double w, double h, Color color) {
    final rect = Rect.fromCenter(center: center, width: w, height: h);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(h / 2));
    canvas.drawRRect(rrect, Paint()..color = color);
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = Colors.black26
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _SorobanPainter oldDelegate) => true;
}
