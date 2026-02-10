// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:park_ticket/core/network/api_client_provider.dart';
// import 'package:park_ticket/features/payment/data/datasources/payment_remote_data_source.dart';
// import 'package:park_ticket/features/payment/data/repositories/payment_repository_impl.dart';
// import 'package:park_ticket/features/payment/domain/entities/payment.dart';
// import 'package:park_ticket/features/payment/domain/repositories/payment_repository.dart';
// import 'package:park_ticket/features/payment/domain/usecases/confirm_payment.dart';

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
