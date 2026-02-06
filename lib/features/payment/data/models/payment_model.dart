import '../../../../core/utils/typedefs.dart';
import '../../../booking/data/models/booking_model.dart';
import '../../../ticket/data/models/ticket_model.dart';
import '../../../booking/domain/entities/booking.dart';
import '../../../ticket/domain/entities/ticket.dart';
import '../../domain/entities/payment.dart';

class PaymentModel extends Payment {
  const PaymentModel({
    required super.bookingId,
    required super.amountCents,
    required super.status,
    super.booking,
    super.ticket,
  });

  factory PaymentModel.fromJson(JsonMap json) {
    return PaymentModel(
      bookingId: json['booking_id'] as String,
      amountCents: json['amount_cents'] as int,
      status: json['status'] as String,
      booking: json['booking'] is JsonMap
          ? BookingModel.fromJson(json['booking'] as JsonMap)
          : null,
      ticket: json['ticket'] is JsonMap
          ? TicketModel.fromJson(json['ticket'] as JsonMap)
          : null,
    );
  }

  JsonMap toJson() {
    return {
      'booking_id': bookingId,
      'amount_cents': amountCents,
      'status': status,
      if (booking is BookingModel)
        'booking': (booking as BookingModel).toJson(),
      if (booking is Booking && booking is! BookingModel)
        'booking': BookingModel(
          id: booking!.id,
          attractionId: booking!.attractionId,
          visitDate: booking!.visitDate,
          timeSlot: booking!.timeSlot,
          quantity: booking!.quantity,
          name: booking!.name,
          email: booking!.email,
          totalCents: booking!.totalCents,
          status: booking!.status,
        ).toJson(),
      if (ticket is TicketModel) 'ticket': (ticket as TicketModel).toJson(),
      if (ticket is Ticket && ticket is! TicketModel)
        'ticket': TicketModel(
          id: ticket!.id,
          bookingId: ticket!.bookingId,
          qrToken: ticket!.qrToken,
          issuedAt: ticket!.issuedAt,
          usedAt: ticket!.usedAt,
        ).toJson(),
    };
  }
}
