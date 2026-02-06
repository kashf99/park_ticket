import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/validation_result.dart';

class ValidationResultModel extends ValidationResult {
  const ValidationResultModel({
    required super.isValid,
    required super.message,
  });

  factory ValidationResultModel.fromJson(JsonMap json) {
    return ValidationResultModel(
      isValid: json['is_valid'] as bool,
      message: json['message'] as String,
    );
  }

  JsonMap toJson() {
    return {
      'is_valid': isValid,
      'message': message,
    };
  }
}
