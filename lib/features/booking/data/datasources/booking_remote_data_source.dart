import '../../../../core/network/api_client.dart';
import '../models/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<BookingModel> createBooking(BookingModel booking);
  Future<BookingModel> getBooking(String id);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final ApiClient client;
  const BookingRemoteDataSourceImpl(this.client);

  @override
  Future<BookingModel> createBooking(BookingModel booking) async {
    final json = await client.post('/bookings', booking.toJson());
    return BookingModel.fromJson(json);
  }

  @override
  Future<BookingModel> getBooking(String id) async {
    final json = await client.get('/bookings/$id');
    return BookingModel.fromJson(json);
  }
}
