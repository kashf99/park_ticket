import 'dart:math' as math;

import 'package:flutter/material.dart';

class HeroPainter extends CustomPainter {
  HeroPainter(this.animation) : super(repaint: animation);

  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final t = animation.value;
    final cycle = t * math.pi * 2;
    final rect = Offset.zero & size;

    final skyPaint = Paint()
      ..shader =
          LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: const [
              Color.fromARGB(255, 0, 9, 25),
              Color.fromARGB(255, 1, 22, 29),
              Color.fromARGB(255, 250, 251, 251),
            ],
            transform: GradientRotation(cycle * 0.22),
          ).createShader(
            Rect.fromLTWH(
              -size.width * 0.35 * math.sin(cycle * 0.7),
              -size.height * 0.2 * math.cos(cycle * 0.7),
              size.width * 1.7,
              size.height * 1.4,
            ),
          );
    canvas.drawRect(rect, skyPaint);

    final ridgeOne = Path()
      ..moveTo(0, size.height * 0.62)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.5,
        size.width,
        size.height * 0.68,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      ridgeOne,
      Paint()
        ..shader =
            LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                Color.fromARGB(255, 23, 109, 111),
                Color.fromARGB(255, 29, 72, 74),
                Color.fromARGB(255, 4, 100, 94),
              ],
              transform: GradientRotation(cycle * 0.25),
            ).createShader(
              Rect.fromLTWH(
                -size.width * 0.2 * math.sin(cycle * 0.6),
                -size.height * 0.1 * math.cos(cycle * 0.6),
                size.width * 1.4,
                size.height * 1.2,
              ),
            ),
    );

    final ridgeTwo = Path()
      ..moveTo(0, size.height * 0.72)
      ..quadraticBezierTo(
        size.width * 0.45,
        size.height * 0.58,
        size.width,
        size.height * 0.8,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      ridgeTwo,
      Paint()
        ..shader =
            LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: const [
                Color.fromARGB(255, 12, 232, 221),
                Color.fromARGB(255, 21, 168, 190),
                Color.fromARGB(255, 29, 112, 145),
              ],
              transform: GradientRotation(-cycle * 0.22),
            ).createShader(
              Rect.fromLTWH(
                -size.width * 0.25 * math.cos(cycle * 0.5),
                -size.height * 0.12 * math.sin(cycle * 0.5),
                size.width * 1.45,
                size.height * 1.25,
              ),
            ),
    );

    final field = Path()
      ..moveTo(0, size.height * 0.82)
      ..quadraticBezierTo(
        size.width * 0.55,
        size.height * 0.72,
        size.width,
        size.height * 0.86,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      field,
      Paint()
        ..shader =
            LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                Color.fromARGB(255, 8, 169, 244),
                Color.fromARGB(255, 15, 90, 137),
                Color.fromARGB(255, 3, 65, 106),
              ],
              transform: GradientRotation(cycle * 0.18),
            ).createShader(
              Rect.fromLTWH(
                -size.width * 0.3 * math.sin(cycle * 0.4),
                -size.height * 0.15 * math.cos(cycle * 0.4),
                size.width * 1.6,
                size.height * 1.35,
              ),
            ),
    );
  }

  @override
  bool shouldRepaint(covariant HeroPainter oldDelegate) => false;
}
