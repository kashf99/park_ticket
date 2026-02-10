class BookingService {
  const BookingService();

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

  String? validateName(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Enter your full name.';
    }
    return null;
  }

  String? validateEmail(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Enter your email address.';
    }
    if (!_emailRegex.hasMatch(trimmed)) {
      return 'Enter a valid email address.';
    }
    return null;
  }
}

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

final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

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
