import 'package:park_ticket/core/utils/formatters.dart';
import 'package:park_ticket/features/attraction/domain/entities/attraction.dart';
import 'package:park_ticket/features/booking/presentation/providers/booking_form_provider.dart';

class BookingViewModel {
  final String attractionName;
  final String visitDateLabel;
  final String timeSlotLabel;
  final String ticketPriceLabel;
  final String totalPriceLabel;
  final String quantityLabel;
  final int totalCents;

  const BookingViewModel({
    required this.attractionName,
    required this.visitDateLabel,
    required this.timeSlotLabel,
    required this.ticketPriceLabel,
    required this.totalPriceLabel,
    required this.quantityLabel,
    required this.totalCents,
  });

  factory BookingViewModel.from({
    required Attraction attraction,
    required BookingFormState state,
  }) {
    final totalCents = attraction.price * state.quantity;
    return BookingViewModel(
      attractionName: attraction.name,
      visitDateLabel: formatShortDate(state.visitDate),
      timeSlotLabel: formatTime(state.timeSlot),
      ticketPriceLabel: formatPrice(attraction.price),
      totalPriceLabel: formatPrice(totalCents),
      quantityLabel: state.quantity.toString(),
      totalCents: totalCents,
    );
  }
}
