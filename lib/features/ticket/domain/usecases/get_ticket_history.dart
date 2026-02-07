import '../entities/ticket_record.dart';
import '../repositories/ticket_repository.dart';

class GetTicketHistory {
  final TicketRepository repository;
  const GetTicketHistory(this.repository);

  Future<List<TicketRecord>> call() {
    return repository.getTicketHistory();
  }
}
