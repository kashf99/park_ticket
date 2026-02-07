import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/theme/app_theme.dart';
import 'features/splash/presentation/pages/splash_page.dart';

void main() {
  runApp(const ProviderScope(child: ParkTicketApp()));
}

class ParkTicketApp extends StatelessWidget {
  const ParkTicketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Park Ticket Entry',
          theme: AppTheme.light(),
          home: child,
        );
      },
      child: const SplashPage(),
    );
  }
}
