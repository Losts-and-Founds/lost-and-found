import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:lost_and_found/utils/colors/custom_color.dart';

/// Step 1: Person dropping a map pin near a wallet ("Report in seconds")
class ReportIllustration extends StatelessWidget {
  final double size;

  const ReportIllustration({super.key, this.size = 220});

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>() ?? lightCustomColors;
    final mintColor = customColors.primaryAccent ?? const Color(0xFF52C46A);
    final strokeColor = customColors.textPrimary ?? const Color(0xFF1E232A);
    final mutedColor = customColors.secondaryTextColor ?? const Color(0xFF8F99A8);

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ReportIllustrationPainter(
          mintColor: mintColor,
          strokeColor: strokeColor,
          mutedColor: mutedColor,
        ),
      ),
    );
  }
}

class _ReportIllustrationPainter extends CustomPainter {
  final Color mintColor;
  final Color strokeColor;
  final Color mutedColor;

  _ReportIllustrationPainter({
    required this.mintColor,
    required this.strokeColor,
    required this.mutedColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintStroke = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final paintMintStroke = Paint()
      ..color = mintColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final paintMintFill = Paint()
      ..color = mintColor.withOpacity(0.18)
      ..style = PaintingStyle.fill;

    final paintMutedStroke = Paint()
      ..color = mutedColor.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // Ground shadow / geo grid lines
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + 65), width: size.width * 0.75, height: 26),
      paintMintFill,
    );
    canvas.drawLine(Offset(cx - 70, cy + 65), Offset(cx + 70, cy + 65), paintMutedStroke);
    canvas.drawLine(Offset(cx - 50, cy + 75), Offset(cx + 50, cy + 75), paintMutedStroke);

    // Leather Wallet on ground
    final walletRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx + 40, cy + 50), width: 75, height: 48),
      const Radius.circular(8),
    );
    canvas.drawRRect(walletRect, paintMintFill);
    canvas.drawRRect(walletRect, paintStroke);
    // Wallet flap & card slot lines
    canvas.drawLine(Offset(cx + 5, cy + 42), Offset(cx + 75, cy + 42), paintStroke);
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx + 60, cy + 50), width: 14, height: 14),
      0,
      math.pi * 2,
      false,
      paintMintStroke,
    );

    // Person dropping pin (Stylized line art figure)
    // Head
    canvas.drawCircle(Offset(cx - 45, cy - 55), 14, paintStroke);
    // Torso & arm reaching forward
    final bodyPath = Path()
      ..moveTo(cx - 45, cy - 40)
      ..lineTo(cx - 40, cy + 10)
      ..lineTo(cx - 55, cy + 62); // leg
    canvas.drawPath(bodyPath, paintStroke);
    // Other leg
    canvas.drawLine(Offset(cx - 40, cy + 10), Offset(cx - 30, cy + 62), paintStroke);
    // Arm dropping the pin
    final armPath = Path()
      ..moveTo(cx - 43, cy - 22)
      ..quadraticBezierTo(cx - 20, cy - 18, cx + 5, cy - 5);
    canvas.drawPath(armPath, paintStroke);

    // Map Pin dropping with motion lines
    final pinCenter = Offset(cx + 10, cy + 5);
    // Pin ripples
    canvas.drawCircle(pinCenter + const Offset(0, 22), 10, paintMutedStroke);
    canvas.drawCircle(pinCenter + const Offset(0, 22), 18, paintMintFill);

    // Map Pin Head & tip
    final pinPath = Path()
      ..moveTo(pinCenter.dx, pinCenter.dy + 18)
      ..cubicTo(pinCenter.dx - 14, pinCenter.dy + 6, pinCenter.dx - 14, pinCenter.dy - 12, pinCenter.dx, pinCenter.dy - 12)
      ..cubicTo(pinCenter.dx + 14, pinCenter.dy - 12, pinCenter.dx + 14, pinCenter.dy + 6, pinCenter.dx, pinCenter.dy + 18)
      ..close();
    canvas.drawPath(pinPath, paintMintFill);
    canvas.drawPath(pinPath, paintMintStroke);
    canvas.drawCircle(pinCenter + const Offset(0, -3), 4.5, Paint()..color = strokeColor);

    // Sparkles / star accents
    _drawSparkle(canvas, Offset(cx - 65, cy - 25), 6, mintColor);
    _drawSparkle(canvas, Offset(cx + 65, cy - 20), 8, mintColor);
    _drawSparkle(canvas, Offset(cx + 75, cy + 20), 5, mintColor);
  }

  void _drawSparkle(Canvas canvas, Offset center, double size, Color color) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(center.dx - size, center.dy), Offset(center.dx + size, center.dy), p);
    canvas.drawLine(Offset(center.dx, center.dy - size), Offset(center.dx, center.dy + size), p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Step 2: Person inspecting a map through a magnifying glass ("Search with precision")
class SearchIllustration extends StatelessWidget {
  final double size;

  const SearchIllustration({super.key, this.size = 220});

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>() ?? lightCustomColors;
    final mintColor = customColors.primaryAccent ?? const Color(0xFF52C46A);
    final strokeColor = customColors.textPrimary ?? const Color(0xFF1E232A);
    final mutedColor = customColors.secondaryTextColor ?? const Color(0xFF8F99A8);

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _SearchIllustrationPainter(
          mintColor: mintColor,
          strokeColor: strokeColor,
          mutedColor: mutedColor,
        ),
      ),
    );
  }
}

class _SearchIllustrationPainter extends CustomPainter {
  final Color mintColor;
  final Color strokeColor;
  final Color mutedColor;

  _SearchIllustrationPainter({
    required this.mintColor,
    required this.strokeColor,
    required this.mutedColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintStroke = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final paintMintStroke = Paint()
      ..color = mintColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round;

    final paintMintFill = Paint()
      ..color = mintColor.withOpacity(0.18)
      ..style = PaintingStyle.fill;

    final paintMutedStroke = Paint()
      ..color = mutedColor.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // Folded Map Tile
    final mapPath = Path()
      ..moveTo(cx - 75, cy + 20)
      ..lineTo(cx - 35, cy + 10)
      ..lineTo(cx + 15, cy + 22)
      ..lineTo(cx + 65, cy + 12)
      ..lineTo(cx + 65, cy + 72)
      ..lineTo(cx + 15, cy + 82)
      ..lineTo(cx - 35, cy + 70)
      ..lineTo(cx - 75, cy + 80)
      ..close();
    canvas.drawPath(mapPath, paintMintFill);
    canvas.drawPath(mapPath, paintStroke);

    // Map internal grid / route lines
    canvas.drawLine(Offset(cx - 35, cy + 10), Offset(cx - 35, cy + 70), paintMutedStroke);
    canvas.drawLine(Offset(cx + 15, cy + 22), Offset(cx + 15, cy + 82), paintMutedStroke);
    final routePath = Path()
      ..moveTo(cx - 55, cy + 50)
      ..quadraticBezierTo(cx - 10, cy + 30, cx + 40, cy + 55);
    canvas.drawPath(
      routePath,
      Paint()
        ..color = mintColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    // Person silhouette inspecting the map
    canvas.drawCircle(Offset(cx - 50, cy - 35), 13, paintStroke); // Head
    final bodyPath = Path()
      ..moveTo(cx - 50, cy - 22)
      ..lineTo(cx - 45, cy + 15) // back
      ..lineTo(cx - 60, cy + 55); // leg
    canvas.drawPath(bodyPath, paintStroke);
    // Arm holding magnifying glass
    canvas.drawLine(Offset(cx - 47, cy - 8), Offset(cx - 5, cy - 5), paintStroke);

    // Large Magnifying Glass
    final magCenter = Offset(cx + 10, cy - 2);
    canvas.drawCircle(magCenter, 30, paintMintFill);
    canvas.drawCircle(magCenter, 30, paintMintStroke);
    // Lens reflection
    canvas.drawArc(
      Rect.fromCircle(center: magCenter, radius: 22),
      -math.pi * 0.75,
      math.pi * 0.4,
      false,
      paintMutedStroke,
    );
    // Handle
    canvas.drawLine(
      magCenter + const Offset(21, 21),
      magCenter + const Offset(42, 42),
      paintStroke..strokeWidth = 4.5,
    );
    paintStroke.strokeWidth = 2.4; // reset

    // Target pinpoint inside magnifying glass
    canvas.drawCircle(magCenter, 6, Paint()..color = mintColor);
    canvas.drawCircle(magCenter, 14, paintMintStroke..strokeWidth = 1.5);

    // Pulse radar concentric rings
    canvas.drawCircle(
      magCenter,
      44,
      Paint()
        ..color = mintColor.withOpacity(0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Step 3: Two people waving with speech bubbles "HELLO!" and "HI!" ("Talk, then reunite")
class TalkIllustration extends StatelessWidget {
  final double size;

  const TalkIllustration({super.key, this.size = 220});

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>() ?? lightCustomColors;
    final mintColor = customColors.primaryAccent ?? const Color(0xFF52C46A);
    final strokeColor = customColors.textPrimary ?? const Color(0xFF1E232A);
    final mutedColor = customColors.secondaryTextColor ?? const Color(0xFF8F99A8);

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _TalkIllustrationPainter(
          mintColor: mintColor,
          strokeColor: strokeColor,
          mutedColor: mutedColor,
        ),
      ),
    );
  }
}

class _TalkIllustrationPainter extends CustomPainter {
  final Color mintColor;
  final Color strokeColor;
  final Color mutedColor;

  _TalkIllustrationPainter({
    required this.mintColor,
    required this.strokeColor,
    required this.mutedColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintStroke = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final paintMintStroke = Paint()
      ..color = mintColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    final paintMintFill = Paint()
      ..color = mintColor.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // Ground line
    canvas.drawLine(
      Offset(cx - 85, cy + 65),
      Offset(cx + 85, cy + 65),
      Paint()
        ..color = mutedColor.withOpacity(0.4)
        ..strokeWidth = 1.8
        ..strokeCap = StrokeCap.round,
    );

    // Person 1 (Left)
    final p1Head = Offset(cx - 48, cy - 25);
    canvas.drawCircle(p1Head, 13, paintStroke);
    // Torso
    canvas.drawLine(Offset(cx - 48, cy - 12), Offset(cx - 48, cy + 28), paintStroke);
    // Legs
    canvas.drawLine(Offset(cx - 48, cy + 28), Offset(cx - 60, cy + 65), paintStroke);
    canvas.drawLine(Offset(cx - 48, cy + 28), Offset(cx - 38, cy + 65), paintStroke);
    // Arm waving upwards
    final p1WaveArm = Path()
      ..moveTo(cx - 48, cy - 2)
      ..lineTo(cx - 65, cy - 15)
      ..lineTo(cx - 72, cy - 35);
    canvas.drawPath(p1WaveArm, paintStroke);
    // Arm holding item towards person 2
    canvas.drawLine(Offset(cx - 48, cy + 8), Offset(cx - 15, cy + 18), paintStroke);

    // Person 2 (Right)
    final p2Head = Offset(cx + 48, cy - 25);
    canvas.drawCircle(p2Head, 13, paintStroke);
    // Torso
    canvas.drawLine(Offset(cx + 48, cy - 12), Offset(cx + 48, cy + 28), paintStroke);
    // Legs
    canvas.drawLine(Offset(cx + 48, cy + 28), Offset(cx + 38, cy + 65), paintStroke);
    canvas.drawLine(Offset(cx + 48, cy + 28), Offset(cx + 60, cy + 65), paintStroke);
    // Arm waving upwards
    final p2WaveArm = Path()
      ..moveTo(cx + 48, cy - 2)
      ..lineTo(cx + 65, cy - 15)
      ..lineTo(cx + 72, cy - 35);
    canvas.drawPath(p2WaveArm, paintStroke);
    // Arm receiving item
    canvas.drawLine(Offset(cx + 48, cy + 8), Offset(cx + 15, cy + 18), paintStroke);

    // Reunited Item (Package / Valuables with heart)
    final boxRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy + 18), width: 26, height: 22),
      const Radius.circular(5),
    );
    canvas.drawRRect(boxRect, paintMintFill);
    canvas.drawRRect(boxRect, paintMintStroke);
    canvas.drawCircle(Offset(cx, cy + 18), 3.5, Paint()..color = mintColor);

    // Speech Bubble 1: "HELLO!" (Left)
    final bubble1Rect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx - 52, cy - 65), width: 68, height: 28),
      const Radius.circular(14),
    );
    canvas.drawRRect(bubble1Rect, paintMintFill);
    canvas.drawRRect(bubble1Rect, paintStroke);
    // Little pointer tip
    final b1Tip = Path()
      ..moveTo(cx - 45, cy - 51)
      ..lineTo(cx - 40, cy - 42)
      ..lineTo(cx - 35, cy - 51);
    canvas.drawPath(b1Tip, paintStroke);

    _drawText(canvas, "HELLO!", Offset(cx - 52, cy - 65), strokeColor, 10, FontWeight.w800);

    // Speech Bubble 2: "HI!" (Right)
    final bubble2Rect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx + 52, cy - 65), width: 50, height: 28),
      const Radius.circular(14),
    );
    canvas.drawRRect(bubble2Rect, paintMintFill);
    canvas.drawRRect(bubble2Rect, paintMintStroke);
    final b2Tip = Path()
      ..moveTo(cx + 38, cy - 51)
      ..lineTo(cx + 42, cy - 42)
      ..lineTo(cx + 48, cy - 51);
    canvas.drawPath(b2Tip, paintMintStroke);

    _drawText(canvas, "HI!", Offset(cx + 52, cy - 65), mintColor, 11, FontWeight.w900);

    // Reunion heart above center
    _drawHeart(canvas, Offset(cx, cy - 25), 8, mintColor);
  }

  void _drawText(Canvas canvas, String text, Offset center, Color color, double fontSize, FontWeight weight) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: weight,
        letterSpacing: 1.1,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - (textPainter.width / 2), center.dy - (textPainter.height / 2)),
    );
  }

  void _drawHeart(Canvas canvas, Offset center, double size, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path();
    path.moveTo(center.dx, center.dy + size * 0.8);
    path.cubicTo(
      center.dx - size * 1.2,
      center.dy - size * 0.2,
      center.dx - size * 1.2,
      center.dy - size * 1.2,
      center.dx,
      center.dy - size * 0.6,
    );
    path.cubicTo(
      center.dx + size * 1.2,
      center.dy - size * 1.2,
      center.dx + size * 1.2,
      center.dy - size * 0.2,
      center.dx,
      center.dy + size * 0.8,
    );
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
