import '../../domain/entities/booking.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_data_source.dart';
import '../models/booking_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remote;
  const BookingRepositoryImpl(this.remote);

  @override
  Future<Booking> createBooking(Booking booking) {
    final model = BookingModel(
      id: booking.id,
      attractionId: booking.attractionId,
      visitDate: booking.visitDate,
      timeSlot: booking.timeSlot,
      quantity: booking.quantity,
      name: booking.name,
      email: booking.email,
      totalCents: booking.totalCents,
      status: booking.status,
      qrToken: booking.qrToken,
    );
    return remote.createBooking(model);
  }

  @override
  Future<Booking> getBooking(String id) {
    return remote.getBooking(id);
  }
}
