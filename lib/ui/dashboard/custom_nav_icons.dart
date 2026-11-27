import 'package:flutter/material.dart';

class CustomNavIcon extends StatelessWidget {
  final int index;
  final Color color;
  final double size;

  const CustomNavIcon({
    Key? key,
    required this.index,
    required this.color,
    this.size = 28.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CustomPainter painter;
    switch (index) {
      case 0:
        painter = _HomePainter(color: color);
        break;
      case 1:
        painter = _AddPainter(color: color);
        break;
      case 2:
        painter = _ChatPainter(color: color);
        break;
      case 3:
      default:
        painter = _UserPainter(color: color);
        break;
    }

    return CustomPaint(size: Size(size, size), painter: painter);
  }
}

class _HomePainter extends CustomPainter {
  final Color color;
  _HomePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;
    final r = w * 0.2;

    final path = Path();

    // Bottom left
    path.moveTo(w * 0.15, h);
    // Bottom right
    path.lineTo(w * 0.85, h);
    path.quadraticBezierTo(w, h, w, h - r);
    // Right wall
    path.lineTo(w, h * 0.45);
    // Roof right curve
    path.quadraticBezierTo(w, h * 0.35, w * 0.9, h * 0.28);
    path.lineTo(w * 0.6, h * 0.05);
    // Roof top peak (rounded)
    path.quadraticBezierTo(w * 0.5, -h * 0.02, w * 0.4, h * 0.05);
    // Roof left
    path.lineTo(w * 0.1, h * 0.28);
    // Roof left curve
    path.quadraticBezierTo(0, h * 0.35, 0, h * 0.45);
    // Left wall
    path.lineTo(0, h - r);
    path.quadraticBezierTo(0, h, w * 0.15, h);

    path.close();

    // The vertical slit in the middle
    final slitPath = Path();
    slitPath.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(w * 0.5, h * 0.75),
          width: w * 0.1,
          height: h * 0.25,
        ),
        Radius.circular(w * 0.05),
      ),
    );

    final combinedPath = Path.combine(PathOperation.difference, path, slitPath);
    canvas.drawPath(combinedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _AddPainter extends CustomPainter {
  final Color color;
  _AddPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;
    final r = w * 0.25;

    final path = Path();

    // Start gap at y = h * 0.4 on right edge
    path.moveTo(w, h * 0.45);
    path.lineTo(w, h - r);
    path.quadraticBezierTo(w, h, w - r, h);
    path.lineTo(r, h);
    path.quadraticBezierTo(0, h, 0, h - r);
    path.lineTo(0, r);
    path.quadraticBezierTo(0, 0, r, 0);
    path.lineTo(w - r, 0);
    path.quadraticBezierTo(w, 0, w, r);
    // End gap at y = h * 0.25 on right edge
    path.lineTo(w, h * 0.25);

    canvas.drawPath(path, paint);

    // Draw plus
    canvas.drawLine(
      Offset(w * 0.35, h * 0.5),
      Offset(w * 0.65, h * 0.5),
      paint,
    );
    canvas.drawLine(
      Offset(w * 0.5, h * 0.35),
      Offset(w * 0.5, h * 0.65),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _ChatPainter extends CustomPainter {
  final Color color;
  _ChatPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;
    final r = w * 0.25;

    final path = Path();
    // Gap for the circle on top right
    path.moveTo(w, h * 0.45);
    path.lineTo(w, h - r);
    path.quadraticBezierTo(w, h, w - r, h);

    // Tail at the bottom, slightly offset from center
    path.lineTo(w * 0.65, h);
    path.lineTo(w * 0.55, h + w * 0.15); // tip of tail
    path.lineTo(w * 0.45, h);

    path.lineTo(r, h);
    path.quadraticBezierTo(0, h, 0, h - r);
    path.lineTo(0, r);
    path.quadraticBezierTo(0, 0, r, 0);
    path.lineTo(w * 0.6, 0);

    canvas.drawPath(path, paint);

    // Draw circle at top right
    canvas.drawCircle(Offset(w * 0.82, h * 0.18), w * 0.18, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _UserPainter extends CustomPainter {
  final Color color;
  _UserPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    // Head circle
    canvas.drawCircle(Offset(w * 0.5, h * 0.25), w * 0.25, paint);

    // Body arc
    final path = Path();
    path.moveTo(w * 0.15, h * 0.95);
    path.quadraticBezierTo(w * 0.5, h * 0.5, w * 0.85, h * 0.95);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
