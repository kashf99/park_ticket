import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:park_ticket/features/attraction/domain/entities/attraction.dart';

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

const defaultBookingTimeSlots = <String>[
  '10:00',
  '10:30',
  '11:00',
  '11:30',
  '12:00',
  '12:30',
  '01:00',
  '01:30',
  '02:00',
  '02:30',
  '03:00',
];

final bookingTimeSlotsProvider = Provider.autoDispose
    .family<List<String>, Attraction>((ref, attraction) {
      final slots = buildTimeSlots(
        attraction.openingTime,
        attraction.closingTime,
      );
      return slots.isEmpty ? defaultBookingTimeSlots : slots;
    });

final bookingCanProceedProvider = Provider.autoDispose<bool>((ref) {
  final state = ref.watch(bookingFormControllerProvider);
  final hasName = state.name.trim().isNotEmpty;
  final hasEmail = state.email.trim().isNotEmpty;
  return hasName && hasEmail;
});

List<String> buildTimeSlots(
  String openingTime,
  String closingTime, {
  Duration step = const Duration(minutes: 30),
}) {
  final start = _parseMinutes(openingTime);
  final end = _parseMinutes(closingTime);
  if (start == null || end == null) {
    return defaultBookingTimeSlots;
  }
  if (end <= start) {
    return defaultBookingTimeSlots;
  }

  final slots = <String>[];
  final lastStart = end - step.inMinutes;
  if (lastStart < start) {
    return defaultBookingTimeSlots;
  }
  for (var minutes = start; minutes <= lastStart; minutes += step.inMinutes) {
    slots.add(_formatMinutes(minutes));
  }
  return slots;
}

int? _parseMinutes(String value) {
  final text = value.trim().toUpperCase();
  final amPmMatch =
      RegExp(r'^(\d{1,2})(?::(\d{2}))?\s*([AP]M)$').firstMatch(text);
  if (amPmMatch != null) {
    var hour = int.tryParse(amPmMatch.group(1)!);
    final minuteText = amPmMatch.group(2);
    final minute = minuteText == null ? 0 : int.tryParse(minuteText);
    final suffix = amPmMatch.group(3);
    if (hour == null || minute == null) return null;
    if (hour == 12) hour = 0;
    if (suffix == 'PM') hour += 12;
    return hour * 60 + minute;
  }

  final match =
      RegExp(r'^(\d{1,2})(?::(\d{2}))?(?::(\d{2})(?:\.\d+)?)?$')
          .firstMatch(text);
  if (match != null) {
    final hour = int.tryParse(match.group(1)!);
    final minuteText = match.group(2);
    final minute = minuteText == null ? 0 : int.tryParse(minuteText);
    if (hour == null || minute == null) return null;
    return hour * 60 + minute;
  }

  final anyMatch = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(text);
  if (anyMatch != null) {
    final hour = int.tryParse(anyMatch.group(1)!);
    final minute = int.tryParse(anyMatch.group(2)!);
    if (hour == null || minute == null) return null;
    return hour * 60 + minute;
  }

  final dateTime = DateTime.tryParse(value);
  if (dateTime != null) {
    return dateTime.hour * 60 + dateTime.minute;
  }
  return null;
}

String _formatMinutes(int minutes) {
  final hour24 = minutes ~/ 60;
  final minute = minutes % 60;
  var hour12 = hour24 % 12;
  if (hour12 == 0) hour12 = 12;
  final hourText = hour12.toString().padLeft(2, '0');
  final minuteText = minute.toString().padLeft(2, '0');
  return '$hourText:$minuteText';
}
