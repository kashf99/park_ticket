import 'package:flutter/foundation.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/storage/local_storage.dart';
import '../models/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<BookingModel> createBooking(BookingModel booking);
  Future<BookingModel> getBooking(String id);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final ApiClient client;
  final LocalStorage storage;
  const BookingRemoteDataSourceImpl(this.client, this.storage);

  @override
  Future<BookingModel> createBooking(BookingModel booking) async {
    final payload = booking.toApiJson();
    final email = (payload['visitorEmail'] ?? '').toString();
    final phone = (payload['phoneNumber'] ?? '').toString();
    await storage.saveUserContact(email: email, phone: phone);
    debugPrint('Create booking payload: $payload');
    final json = await client.post('/api/bookings', payload);
    debugPrint('Create booking response: $json');
    return BookingModel.fromJson(json);
  }

  @override
  Future<BookingModel> getBooking(String id) async {
    final json = await client.get('/api/bookings/$id',{});
    return BookingModel.fromJson(json);
  }
}
