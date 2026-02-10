import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:park_ticket/features/attraction/domain/entities/attraction.dart';

import '../view_models/booking_view_model.dart';
import 'booking_form_provider.dart';

final bookingViewModelProvider = Provider.autoDispose
    .family<BookingViewModel, Attraction>((ref, attraction) {
  final state = ref.watch(bookingFormControllerProvider);
  return BookingViewModel.from(attraction: attraction, state: state);
});
