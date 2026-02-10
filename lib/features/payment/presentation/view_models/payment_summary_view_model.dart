import 'package:park_ticket/core/utils/formatters.dart';
import 'package:park_ticket/features/attraction/domain/entities/attraction.dart';
import 'package:park_ticket/features/booking/domain/entities/booking.dart';

class PaymentSummaryViewModel {
  final String attractionName;
  final String dateLabel;
  final String timeLabel;
  final int tickets;
  final String totalLabel;

  const PaymentSummaryViewModel({
    required this.attractionName,
    required this.dateLabel,
    required this.timeLabel,
    required this.tickets,
    required this.totalLabel,
  });

  factory PaymentSummaryViewModel.from({
    required Attraction attraction,
    required Booking booking,
  }) {
    return PaymentSummaryViewModel(
      attractionName: attraction.name,
      dateLabel: _formatDate(booking.visitDate),
      timeLabel: formatTime(booking.timeSlot),
      tickets: booking.quantity,
      totalLabel: formatPrice(booking.totalCents),
    );
  }
}

String _formatDate(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}
