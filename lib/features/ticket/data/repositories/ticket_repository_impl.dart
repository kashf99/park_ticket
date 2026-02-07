import '../../domain/entities/ticket_record.dart';
import '../../domain/repositories/ticket_repository.dart';
import '../datasources/ticket_remote_data_source.dart';

class TicketRepositoryImpl implements TicketRepository {
  final TicketRemoteDataSource remote;
  const TicketRepositoryImpl(this.remote);



  @override
  Future<List<TicketRecord>> getTicketHistory() {
    return remote.fetchTicketHistory();
  }
}
