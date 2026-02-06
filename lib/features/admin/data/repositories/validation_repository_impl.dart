import '../../domain/entities/validation_result.dart';
import '../../domain/repositories/validation_repository.dart';
import '../datasources/validation_remote_data_source.dart';

class ValidationRepositoryImpl implements ValidationRepository {
  final ValidationRemoteDataSource remote;
  const ValidationRepositoryImpl(this.remote);

  @override
  Future<ValidationResult> validateTicket(String qrToken) {
    return remote.validateTicket(qrToken);
  }
}
