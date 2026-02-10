import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:park_ticket/features/attraction/domain/entities/attraction.dart';

import 'booking_service_provider.dart';

class BookingFormState {
  final DateTime visitDate;
  final String timeSlot;
  final int quantity;
  final String name;
  final String email;

  const BookingFormState({
    required this.visitDate,
    required this.timeSlot,
    required this.quantity,
    required this.name,
    required this.email,
  });

  BookingFormState copyWith({
    DateTime? visitDate,
    String? timeSlot,
    int? quantity,
    String? name,
    String? email,
  }) {
    return BookingFormState(
      visitDate: visitDate ?? this.visitDate,
      timeSlot: timeSlot ?? this.timeSlot,
      quantity: quantity ?? this.quantity,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}

class BookingFormController extends AutoDisposeNotifier<BookingFormState> {
  @override
  BookingFormState build() {
    final now = DateTime.now();
    return BookingFormState(
      visitDate: DateTime(now.year, now.month, now.day),
      timeSlot: '',
      quantity: 1,
      name: '',
      email: '',
    );
  }

  void setVisitDate(DateTime date) {
    state = state.copyWith(
      visitDate: DateTime(date.year, date.month, date.day),
    );
  }

  void setTimeSlot(String slot) {
    state = state.copyWith(timeSlot: slot);
  }

  void incrementQuantity() {
    state = state.copyWith(quantity: state.quantity + 1);
  }

  void decrementQuantity() {
    if (state.quantity <= 1) return;
    state = state.copyWith(quantity: state.quantity - 1);
  }

  void setName(String value) {
    state = state.copyWith(name: value);
  }

  void setEmail(String value) {
    state = state.copyWith(email: value);
  }
}

final bookingFormControllerProvider =
    AutoDisposeNotifierProvider<BookingFormController, BookingFormState>(
      BookingFormController.new,
    );

final bookingTimeSlotsProvider = Provider.autoDispose
    .family<List<String>, Attraction>((ref, attraction) {
      final service = ref.read(bookingServiceProvider);
      return service.buildTimeSlots(
        attraction.openingTime,
        attraction.closingTime,
      );
    });
