import 'package:flutter/material.dart';

/// Calendar binding, a continuous trail, and a small sun: the Zhouji mark.
class ZhoujiMark extends StatelessWidget {
  const ZhoujiMark({super.key, this.size = 40});
  final double size;

  @override
  Widget build(BuildContext context) => Semantics(
    label: '周迹',
    image: true,
    child: SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _MarkPainter()),
    ),
  );
}

class _MarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 108, size.height / 108);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(0, 0, 108, 108),
        const Radius.circular(28),
      ),
      Paint()..color = const Color(0xFF176B5B),
    );
    final stroke =
        Paint()
          ..color = const Color(0xFFF5F8EE)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(27, 30, 54, 51),
        const Radius.circular(12),
      ),
      stroke,
    );
    canvas.drawLine(const Offset(40, 24), const Offset(40, 36), stroke);
    canvas.drawLine(const Offset(68, 24), const Offset(68, 36), stroke);
    canvas.drawPath(
      Path()
        ..moveTo(39, 51)
        ..lineTo(67, 51)
        ..lineTo(41, 68)
        ..lineTo(60, 68),
      stroke,
    );
    canvas.drawCircle(
      const Offset(70, 68),
      4,
      Paint()..color = const Color(0xFFE9C978),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
