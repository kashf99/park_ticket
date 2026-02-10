import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/booking.dart';
import 'package:park_ticket/features/booking/di/booking_di.dart';

class BookingSubmissionState {
  final bool isSubmitting;
  final String? errorMessage;

  const BookingSubmissionState({
    required this.isSubmitting,
    required this.errorMessage,
  });

  factory BookingSubmissionState.initial() {
    return const BookingSubmissionState(
      isSubmitting: false,
      errorMessage: null,
    );
  }

  BookingSubmissionState copyWith({
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return BookingSubmissionState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }
}

class BookingSubmissionController
    extends AutoDisposeNotifier<BookingSubmissionState> {
  @override
  BookingSubmissionState build() => BookingSubmissionState.initial();

  Future<Booking?> submit(Booking booking) async {
    if (state.isSubmitting) return null;
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      final createBooking = ref.read(createBookingProvider);
      final created = await createBooking(booking);
      return created;
    } catch (error) {
      state = state.copyWith(errorMessage: error.toString());
      return null;
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }
}

final bookingSubmissionControllerProvider =
    AutoDisposeNotifierProvider<BookingSubmissionController, BookingSubmissionState>(
  BookingSubmissionController.new,
);
