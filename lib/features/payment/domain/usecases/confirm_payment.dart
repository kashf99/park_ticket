import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

class ConfirmPayment {
  final PaymentRepository repository;
  const ConfirmPayment(this.repository);

  Future<Payment> call(String bookingId) {
    return repository.confirmPayment(bookingId);
  }
}
