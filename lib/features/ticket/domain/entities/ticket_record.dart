import '../../../booking/domain/entities/booking.dart';
import 'ticket.dart';

class TicketRecord {
  final Booking booking;
  final Ticket ticket;

  const TicketRecord({
    required this.booking,
    required this.ticket,
  });
}
