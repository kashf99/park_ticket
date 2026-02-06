import '../entities/validation_result.dart';

abstract class ValidationRepository {
  Future<ValidationResult> validateTicket(String qrToken);
}
