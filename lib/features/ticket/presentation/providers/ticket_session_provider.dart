import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:park_ticket/features/booking/domain/entities/booking.dart';
import 'package:park_ticket/features/ticket/domain/entities/ticket.dart';

class TicketSnapshot {
  final Booking booking;
  final Ticket ticket;

  const TicketSnapshot({
    required this.booking,
    required this.ticket,
  });
}

final lastTicketBookingIdProvider = StateProvider<String?>((ref) => null);
final lastTicketSnapshotProvider =
    StateProvider<TicketSnapshot?>((ref) => null);

class TicketHistoryController extends StateNotifier<List<TicketSnapshot>> {
  TicketHistoryController() : super(const []);

  void upsert(TicketSnapshot snapshot) {
    final index =
        state.indexWhere((item) => item.booking.id == snapshot.booking.id);
    if (index == -1) {
      state = [snapshot, ...state];
      return;
    }
    final updated = [...state];
    updated[index] = snapshot;
    state = updated;
  }
}

final ticketHistoryProvider =
    StateNotifierProvider<TicketHistoryController, List<TicketSnapshot>>(
  (ref) => TicketHistoryController(),
);
