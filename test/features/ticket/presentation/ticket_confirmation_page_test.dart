import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:park_ticket/features/booking/domain/entities/booking.dart';
import 'package:park_ticket/features/ticket/domain/entities/ticket.dart';
import 'package:park_ticket/features/ticket/presentation/pages/ticket_confirmation_page.dart';
import 'package:park_ticket/features/ticket/presentation/providers/ticket_session_provider.dart';

void main() {
  final booking = Booking(
    id: 'b1',
    attractionId: 'a1',
    visitDate: DateTime(2026, 2, 8),
    timeSlot: '10:00 AM',
    quantity: 2,
    name: 'John Doe',
    email: 'john@doe.com',
    totalCents: 6000,
    status: 'confirmed',
    attractionName: 'Bridge',
    totalAmount: 50,
    taxAmount: 10,
    finalAmount: 60,
    qrCodeImage: '',
  );

  final ticket = Ticket(
    id: 't1',
    bookingId: 'b1',
    qrToken: 'qr123',
    issuedAt: DateTime(2026, 2, 8),
    usedAt: null,
  );

  testWidgets('shows amount only, no tax/total rows', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          lastTicketSnapshotProvider.overrideWith((ref) =>
              TicketSnapshot(booking: booking, ticket: ticket)),
        ],
        child: const MaterialApp(home: TicketConfirmationPage()),
      ),
    );

    await tester.pump();
    expect(find.text('Amount'), findsOneWidget);
    expect(find.text('Tax'), findsNothing);
    expect(find.text('Total'), findsNothing);
  });
}
