import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_ticket/core/widgets/app_shell.dart';
import 'package:park_ticket/features/splash/presentation/widgets/glass_card.dart';
import 'package:park_ticket/features/splash/presentation/widgets/hero_scene.dart';
import 'package:park_ticket/features/splash/presentation/widgets/logo_mark.dart';
import 'package:park_ticket/features/splash/presentation/widgets/start_button.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 1, 18, 22),
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
                        child: Opacity(opacity: 0.55, child: HeroScene()),
                      ),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.05),
                                Colors.black.withValues(alpha: 0.25),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 26.h,
                        left: 0,
                        right: 0,
                        child: const Center(child: LogoMark()),
                      ),
                      Positioned(
                        left: 20.w,
                        right: 20.w,
                        bottom: 104.h,
                        child: const GlassCard(),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 26.h,
                        child: StartButton(
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
