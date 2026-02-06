import '../entities/booking.dart';
import '../repositories/booking_repository.dart';

class GetBooking {
  final BookingRepository repository;
  const GetBooking(this.repository);

  Future<Booking> call(String id) {
    return repository.getBooking(id);
  }
}
