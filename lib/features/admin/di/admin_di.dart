import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:park_ticket/core/network/api_client_provider.dart';
import 'package:park_ticket/features/admin/data/datasources/validation_remote_data_source.dart';
import 'package:park_ticket/features/admin/data/repositories/validation_repository_impl.dart';
import 'package:park_ticket/features/admin/domain/entities/validation_result.dart';
import 'package:park_ticket/features/admin/domain/repositories/validation_repository.dart';
import 'package:park_ticket/features/admin/domain/usecases/validate_ticket.dart';

final validationRemoteDataSourceProvider = Provider<ValidationRemoteDataSource>(
  (ref) {
    final client = ref.read(apiClientProvider);
    return ValidationRemoteDataSourceImpl(client);
  },
);

final validationRepositoryProvider = Provider<ValidationRepository>((ref) {
  final remote = ref.read(validationRemoteDataSourceProvider);
  return ValidationRepositoryImpl(remote);
});

final validateTicketProvider = Provider<ValidateTicket>((ref) {
  final repo = ref.read(validationRepositoryProvider);
  return ValidateTicket(repo);
});

final validationProvider = FutureProvider.family<ValidationResult, String>(
  (ref, qrToken) {
    return ref.read(validateTicketProvider)(qrToken);
  },
);
