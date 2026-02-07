import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:park_ticket/core/widgets/app_shell.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  static const Color _cardText = Color(0xFFF8F4F2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 1, 88, 107),
              Color.fromARGB(255, 17, 18, 18),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 18.h),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 420.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(36.r),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/splash_background.jpg',

                          fit: BoxFit.cover,
                        ),
                      ),
                      const Positioned.fill(
                        child: Opacity(opacity: 0.55, child: _HeroScene()),
                      ),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.05),
                                Colors.black.withOpacity(0.25),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 26.h,
                        left: 0,
                        right: 0,
                        child: const Center(child: _LogoMark()),
                      ),
                      Positioned(
                        left: 20.w,
                        right: 20.w,
                        bottom: 104.h,
                        child: const _GlassCard(),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 26.h,
                        child: _StartButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const AppShell(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        'assets/icons/park_ticket_logo.svg',
        height: 120.h,
        width: 120.h,
        fit: BoxFit.contain,
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: Colors.white.withOpacity(0.35)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enjoy your\ntravel experience',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: SplashPage._cardText,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Discover parks, plan your day, and\n'
                'secure tickets in seconds.\n'
                'Your next adventure starts here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.78),
                  fontSize: 11.sp,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StartButton extends StatefulWidget {
  const _StartButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends State<_StartButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final t = _controller.value;
            final cycle = t * math.pi * 2;
            return Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.15),
                border: Border.all(
                  color: Colors.white.withOpacity(0.6),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Container(
                width: 54.w,
                height: 54.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: const [
                      Color.fromARGB(255, 67, 215, 239),
                      Color.fromARGB(255, 47, 155, 196),
                      Color.fromARGB(255, 35, 96, 140),
                    ],
                    transform: GradientRotation(cycle),
                  ),
                ),
                child: child,
              ),
            );
          },
          child: const Icon(Icons.arrow_forward, color: Colors.white),
        ),
      ),
    );
  }
}

class _HeroScene extends StatefulWidget {
  const _HeroScene();

  @override
  State<_HeroScene> createState() => _HeroSceneState();
}

class _HeroSceneState extends State<_HeroScene>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _HeroPainter(_controller),
      child: const SizedBox.expand(),
    );
  }
}

class _HeroPainter extends CustomPainter {
  _HeroPainter(this.animation) : super(repaint: animation);

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
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 5, 64, 76),
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

    final sunRadius = size.width * 0.35;
    final sunRect = Rect.fromCircle(
      center: Offset(size.width * 0.74, size.height * 0.28),
      radius: sunRadius,
    );
    final sunPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color.fromARGB(255, 19, 208, 183).withOpacity(0.75),
          const Color.fromARGB(255, 130, 157, 162).withOpacity(0.25),
        ],
        center: Alignment(
          0.2 * math.sin(cycle * 0.8),
          0.2 * math.cos(cycle * 0.8),
        ),
        radius: 0.9,
      ).createShader(sunRect);
    canvas.drawCircle(sunRect.center, sunRadius, sunPaint);

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
  bool shouldRepaint(covariant _HeroPainter oldDelegate) => false;
}
