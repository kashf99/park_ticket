import '../../../../core/network/api_client.dart';
import '../models/payment_model.dart';

abstract class PaymentRemoteDataSource {
  Future<PaymentModel> confirmPayment(String bookingId);
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final ApiClient client;
  const PaymentRemoteDataSourceImpl(this.client);

  @override
  Future<PaymentModel> confirmPayment(String bookingId) async {
    final json = await client.post('/bookings/$bookingId/confirm-payment', {});
    return PaymentModel.fromJson(json);
  }
}
