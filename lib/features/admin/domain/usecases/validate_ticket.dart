import '../entities/validation_result.dart';
import '../repositories/validation_repository.dart';

class ValidateTicket {
  final ValidationRepository repository;
  const ValidateTicket(this.repository);

  Future<ValidationResult> call(String qrToken) {
    return repository.validateTicket(qrToken);
  }
}
