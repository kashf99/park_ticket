import 'package:park_ticket/features/booking/domain/entities/booking.dart';
import 'package:park_ticket/features/ticket/domain/entities/ticket.dart';

class Payment {
  final String bookingId;
  final int amountCents;
  final String status;
  final Booking? booking;
  final Ticket? ticket;

  const Payment({
    required this.bookingId,
    required this.amountCents,
    required this.status,
    this.booking,
    this.ticket,
  });

  Payment copyWith({
    String? bookingId,
    int? amountCents,
    String? status,
    Booking? booking,
    Ticket? ticket,
  }) {
    return Payment(
      bookingId: bookingId ?? this.bookingId,
      amountCents: amountCents ?? this.amountCents,
      status: status ?? this.status,
      booking: booking ?? this.booking,
      ticket: ticket ?? this.ticket,
    );
  }
}
