import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/booking_service.dart';

final bookingServiceProvider = Provider<BookingService>((ref) {
  return const BookingService();
});
