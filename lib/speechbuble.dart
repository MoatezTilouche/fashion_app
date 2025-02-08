import 'package:flutter/material.dart';

class SpeechBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    // Start drawing the speech bubble
    path.moveTo(30, 0); // Start near the top left but leave space for the curve
    path.quadraticBezierTo(5, 0, 10, 20); // Top-left curve
    path.lineTo(10, size.height / 2 - 10); // Left side down before the triangle

    // Tail of the bubble (on the left side)
    path.lineTo(0, size.height / 2); // Point of the triangle
    path.lineTo(10, size.height / 2 + 10); // Continue after the triangle

    path.lineTo(10, size.height - 20); // Left side continues
    path.quadraticBezierTo(5, size.height, 30, size.height); // Bottom-left curve
    path.lineTo(size.width - 30, size.height); // Bottom straight line
    path.quadraticBezierTo(size.width - 5, size.height, size.width - 10,
        size.height - 20); // Bottom-right curve
    path.lineTo(size.width - 10, 20); // Right side
    path.quadraticBezierTo(
        size.width - 5, 0, size.width - 30, 0); // Top-right curve
    path.lineTo(30, 0); // Top straight line

    // Draw the final path
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}


