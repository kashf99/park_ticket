import 'package:flutter/material.dart';
import 'package:park_ticket/features/splash/presentation/widgets/hero_painter.dart';

class HeroScene extends StatefulWidget {
  const HeroScene({super.key});

  @override
  State<HeroScene> createState() => _HeroSceneState();
}

class _HeroSceneState extends State<HeroScene>
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
      painter: HeroPainter(_controller),
      child: const SizedBox.expand(),
    );
  }
}
