import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/validation_result.dart';

class ValidationResultModel extends ValidationResult {
  const ValidationResultModel({
    required super.isValid,
    required super.message,
  });

  factory ValidationResultModel.fromJson(JsonMap json) {
    final root = json;
    final data = root['data'] is Map
        ? (root['data'] as Map).map(
            (key, value) => MapEntry(key.toString(), value),
          )
        : null;
    final booking = root['booking'] is Map
        ? (root['booking'] as Map).map(
            (key, value) => MapEntry(key.toString(), value),
          )
        : null;
    final normalized = data ?? booking ?? root;

    final isValidValue = normalized['is_valid'] ??
        normalized['isValid'] ??
        normalized['valid'] ??
        normalized['isQRValidated'] ??
        normalized['is_qr_validated'] ??
        root['success'];
    return ValidationResultModel(
      isValid: isValidValue is bool ? isValidValue : false,
      message: (normalized['message'] ??
              root['message'] ??
              normalized['detail'] ??
              normalized['error'] ??
              'Ticket validation completed.')
          .toString(),
    );
  }

  JsonMap toJson() {
    return {
      'is_valid': isValid,
      'message': message,
    };
  }
}
