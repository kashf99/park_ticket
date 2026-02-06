import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client_provider.dart';
import '../../data/datasources/ticket_remote_data_source.dart';
import '../../data/repositories/ticket_repository_impl.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/repositories/ticket_repository.dart';
import '../../domain/usecases/get_ticket.dart';

final ticketRemoteDataSourceProvider = Provider<TicketRemoteDataSource>((ref) {
  final client = ref.read(apiClientProvider);
  return TicketRemoteDataSourceImpl(client);
});

final ticketRepositoryProvider = Provider<TicketRepository>((ref) {
  final remote = ref.read(ticketRemoteDataSourceProvider);
  return TicketRepositoryImpl(remote);
});

final getTicketProvider = Provider<GetTicket>((ref) {
  final repo = ref.read(ticketRepositoryProvider);
  return GetTicket(repo);
});

final ticketProvider = FutureProvider.family<Ticket, String>((ref, bookingId) {
  return ref.read(getTicketProvider)(bookingId);
});
