import '../../domain/entities/ticket.dart';
import '../../domain/repositories/ticket_repository.dart';
import '../datasources/ticket_remote_data_source.dart';

class TicketRepositoryImpl implements TicketRepository {
  final TicketRemoteDataSource remote;
  const TicketRepositoryImpl(this.remote);

  @override
  Future<Ticket> getTicket(String bookingId) {
    return remote.fetchTicket(bookingId);
  }
}
