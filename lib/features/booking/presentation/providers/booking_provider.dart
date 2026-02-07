import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client_provider.dart';
import '../../../../core/storage/local_storage_provider.dart';
import '../../data/datasources/booking_remote_data_source.dart';
import '../../data/repositories/booking_repository_impl.dart';
import '../../domain/entities/booking.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../domain/usecases/create_booking.dart';
import '../../domain/usecases/get_booking.dart';

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

final bookingSubmissionProvider = FutureProvider.family<Booking, Booking>((ref, booking) {
  return ref.read(createBookingProvider)(booking);
});

final bookingProvider = FutureProvider.family<Booking, String>((ref, id) {
  return ref.read(getBookingProvider)(id);
});
