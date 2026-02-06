import '../entities/booking.dart';
import '../repositories/booking_repository.dart';

class CreateBooking {
  final BookingRepository repository;
  const CreateBooking(this.repository);

  Future<Booking> call(Booking booking) {
    return repository.createBooking(booking);
  }
}
