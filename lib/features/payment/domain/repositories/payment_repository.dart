import '../entities/payment.dart';

abstract class PaymentRepository {
  Future<Payment> confirmPayment(String bookingId);
}
