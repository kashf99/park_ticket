import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:park_ticket/core/theme/app_colors.dart';
import 'package:park_ticket/features/admin/presentation/pages/admin_login_page.dart';
import 'package:park_ticket/features/attraction/presentation/pages/attraction_page.dart';
import 'package:park_ticket/features/ticket/presentation/pages/ticket_history_page.dart';

final appTabIndexProvider = StateProvider<int>((ref) => 0);

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(appTabIndexProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          AttractionPage(),
          AdminLoginPage(),
          TicketHistoryPage(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) =>
              ref.read(appTabIndexProvider.notifier).state = index,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.brand,
          unselectedItemColor: AppColors.inkMuted,
          backgroundColor: Colors.white,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.place_outlined),
              activeIcon: Icon(Icons.place),
              label: 'Attraction',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.admin_panel_settings_outlined),
              activeIcon: Icon(Icons.admin_panel_settings),
              label: 'Admin',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.confirmation_number_outlined),
              activeIcon: Icon(Icons.confirmation_number),
              label: 'Tickets',
            ),
          ],
        ),
      ),
    );
  }
}
