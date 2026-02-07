// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../../../core/network/api_client_provider.dart';
// import '../../data/datasources/payment_remote_data_source.dart';
// import '../../data/repositories/payment_repository_impl.dart';
// import '../../domain/entities/payment.dart';
// import '../../domain/repositories/payment_repository.dart';
// import '../../domain/usecases/confirm_payment.dart';

// final paymentRemoteDataSourceProvider = Provider<PaymentRemoteDataSource>((ref) {
//   final client = ref.read(apiClientProvider);
//   return PaymentRemoteDataSourceImpl(client);
// });

// final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
//   final remote = ref.read(paymentRemoteDataSourceProvider);
//   return PaymentRepositoryImpl(remote);
// });

// final confirmPaymentProvider = Provider<ConfirmPayment>((ref) {
//   final repo = ref.read(paymentRepositoryProvider);
//   return ConfirmPayment(repo);
// });

// final paymentProvider = FutureProvider.family<Payment, String>((ref, bookingId) {
//   return ref.read(confirmPaymentProvider)(bookingId);
// });
