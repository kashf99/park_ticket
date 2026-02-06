import '../../domain/entities/payment.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_remote_data_source.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remote;
  const PaymentRepositoryImpl(this.remote);

  @override
  Future<Payment> confirmPayment(String bookingId) {
    return remote.confirmPayment(bookingId);
  }
}
