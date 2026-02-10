import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_ticket/features/attraction/di/attraction_di.dart';

import 'package:park_ticket/features/attraction/domain/entities/attraction.dart';
import 'package:park_ticket/features/attraction/presentation/pages/attractions_page.dart';

void main() {
  final sample = [
    const Attraction(
      id: '1',
      name: 'Lake',
      description: 'Nice place',
      openingTime: '09:00 AM',
      closingTime: '06:00 PM',
      price: 20,
      featuredImage: '',
    ),
    const Attraction(
      id: '2',
      name: 'Bridge',
      description: 'Glass bridge',
      openingTime: '09:00 AM',
      closingTime: '06:00 PM',
      price: 25,
      featuredImage: '',
    ),
  ];

  testWidgets('renders list and supports pull-to-refresh', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          attractionsProvider.overrideWith((ref) async => sample),
        ],
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          child: const MaterialApp(home: AttractionsPage()),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Lake'), findsOneWidget);
    expect(find.text('Bridge'), findsOneWidget);

    // Trigger refresh indicator
    await tester.drag(find.byType(ListView), const Offset(0, 300));
    await tester.pump(); // start
    await tester.pump(const Duration(seconds: 1)); // finish animation
  });

  testWidgets('filters by search query', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          attractionsProvider.overrideWith((ref) async => sample),
        ],
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          child: const MaterialApp(home: AttractionsPage()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'bridge');
    await tester.pumpAndSettle();

    expect(find.text('Bridge'), findsOneWidget);
    expect(find.text('Lake'), findsNothing);
  });
}
