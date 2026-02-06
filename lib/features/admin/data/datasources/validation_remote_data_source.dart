import '../../../../core/network/api_client.dart';
import '../models/validation_result_model.dart';

abstract class ValidationRemoteDataSource {
  Future<ValidationResultModel> validateTicket(String qrToken);
}

class ValidationRemoteDataSourceImpl implements ValidationRemoteDataSource {
  final ApiClient client;
  const ValidationRemoteDataSourceImpl(this.client);

  @override
  Future<ValidationResultModel> validateTicket(String qrToken) async {
    final json = await client.post('/tickets/validate', {'qr_token': qrToken});
    return ValidationResultModel.fromJson(json);
  }
}
