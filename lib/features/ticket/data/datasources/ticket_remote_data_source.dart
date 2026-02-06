import '../../../../core/network/api_client.dart';
import '../models/ticket_model.dart';

abstract class TicketRemoteDataSource {
  Future<TicketModel> fetchTicket(String bookingId);
}

class TicketRemoteDataSourceImpl implements TicketRemoteDataSource {
  final ApiClient client;
  const TicketRemoteDataSourceImpl(this.client);

  @override
  Future<TicketModel> fetchTicket(String bookingId) async {
    final json = await client.get('/tickets/$bookingId');
    return TicketModel.fromJson(json);
  }
}
