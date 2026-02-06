import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/ticket.dart';

class TicketModel extends Ticket {
  const TicketModel({
    required super.id,
    required super.bookingId,
    required super.qrToken,
    required super.issuedAt,
    required super.usedAt,
  });

  factory TicketModel.fromJson(JsonMap json) {
    return TicketModel(
      id: json['id'] as String,
      bookingId: json['booking_id'] as String,
      qrToken: json['qr_token'] as String,
      issuedAt: DateTime.parse(json['issued_at'] as String),
      usedAt: json['used_at'] == null ? null : DateTime.parse(json['used_at'] as String),
    );
  }

  JsonMap toJson() {
    return {
      'id': id,
      'booking_id': bookingId,
      'qr_token': qrToken,
      'issued_at': issuedAt.toIso8601String(),
      'used_at': usedAt?.toIso8601String(),
    };
  }
}
