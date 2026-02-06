import '../entities/ticket.dart';

abstract class TicketRepository {
  Future<Ticket> getTicket(String bookingId);
}
