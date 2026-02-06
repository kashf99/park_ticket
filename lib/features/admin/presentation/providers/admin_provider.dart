import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client_provider.dart';
import '../../data/datasources/validation_remote_data_source.dart';
import '../../data/repositories/validation_repository_impl.dart';
import '../../domain/entities/validation_result.dart';
import '../../domain/repositories/validation_repository.dart';
import '../../domain/usecases/validate_ticket.dart';

final validationRemoteDataSourceProvider = Provider<ValidationRemoteDataSource>((ref) {
  final client = ref.read(apiClientProvider);
  return ValidationRemoteDataSourceImpl(client);
});

final validationRepositoryProvider = Provider<ValidationRepository>((ref) {
  final remote = ref.read(validationRemoteDataSourceProvider);
  return ValidationRepositoryImpl(remote);
});

final validateTicketProvider = Provider<ValidateTicket>((ref) {
  final repo = ref.read(validationRepositoryProvider);
  return ValidateTicket(repo);
});

final validationProvider = FutureProvider.family<ValidationResult, String>((ref, qrToken) {
  return ref.read(validateTicketProvider)(qrToken);
});
