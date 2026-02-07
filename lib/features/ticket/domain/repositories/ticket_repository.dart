import '../entities/ticket_record.dart';

abstract class TicketRepository {

  Future<List<TicketRecord>> getTicketHistory();
}
