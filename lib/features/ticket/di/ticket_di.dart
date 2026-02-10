import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:park_ticket/core/network/api_client_provider.dart';
import 'package:park_ticket/core/storage/local_storage_provider.dart';
import 'package:park_ticket/features/ticket/data/datasources/ticket_remote_data_source.dart';
import 'package:park_ticket/features/ticket/data/repositories/ticket_repository_impl.dart';
import 'package:park_ticket/features/ticket/domain/entities/ticket_record.dart';
import 'package:park_ticket/features/ticket/domain/repositories/ticket_repository.dart';
import 'package:park_ticket/features/ticket/domain/usecases/get_ticket_history.dart';

final ticketRemoteDataSourceProvider = Provider<TicketRemoteDataSource>((ref) {
  final client = ref.read(apiClientProvider);
  final storage = ref.read(localStorageProvider);
  return TicketRemoteDataSourceImpl(client, storage);
});

final ticketRepositoryProvider = Provider<TicketRepository>((ref) {
  final remote = ref.read(ticketRemoteDataSourceProvider);
  return TicketRepositoryImpl(remote);
});

final getTicketHistoryProvider = Provider<GetTicketHistory>((ref) {
  final repo = ref.read(ticketRepositoryProvider);
  return GetTicketHistory(repo);
});

final ticketHistoryRemoteProvider = FutureProvider<List<TicketRecord>>((ref) {
  return ref.read(getTicketHistoryProvider)();
});
