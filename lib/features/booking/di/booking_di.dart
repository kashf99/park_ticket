import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:park_ticket/core/network/api_client_provider.dart';
import 'package:park_ticket/core/storage/local_storage_provider.dart';
import 'package:park_ticket/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:park_ticket/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:park_ticket/features/booking/domain/entities/booking.dart';
import 'package:park_ticket/features/booking/domain/repositories/booking_repository.dart';
import 'package:park_ticket/features/booking/domain/services/booking_service.dart';
import 'package:park_ticket/features/booking/domain/usecases/create_booking.dart';
import 'package:park_ticket/features/booking/domain/usecases/get_booking.dart';

final bookingRemoteDataSourceProvider = Provider<BookingRemoteDataSource>((ref) {
  final client = ref.read(apiClientProvider);
  final storage = ref.read(localStorageProvider);
  return BookingRemoteDataSourceImpl(client, storage);
});

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  final remote = ref.read(bookingRemoteDataSourceProvider);
  return BookingRepositoryImpl(remote);
});

final createBookingProvider = Provider<CreateBooking>((ref) {
  final repo = ref.read(bookingRepositoryProvider);
  return CreateBooking(repo);
});

final getBookingProvider = Provider<GetBooking>((ref) {
  final repo = ref.read(bookingRepositoryProvider);
  return GetBooking(repo);
});

final bookingSubmissionProvider = FutureProvider.family<Booking, Booking>(
  (ref, booking) {
    return ref.read(createBookingProvider)(booking);
  },
);

final bookingProvider = FutureProvider.family<Booking, String>((ref, id) {
  return ref.read(getBookingProvider)(id);
});

final bookingServiceProvider = Provider<BookingService>((ref) {
  return const BookingService();
});
