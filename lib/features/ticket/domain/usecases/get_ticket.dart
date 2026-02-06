import '../entities/ticket.dart';
import '../repositories/ticket_repository.dart';

class GetTicket {
  final TicketRepository repository;
  const GetTicket(this.repository);

  Future<Ticket> call(String bookingId) {
    return repository.getTicket(bookingId);
  }
}
