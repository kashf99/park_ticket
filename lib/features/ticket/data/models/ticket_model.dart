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
    final data = _extractData(json);
    return TicketModel(
      id: (data['ticketId'] ?? data['id'] ?? data['bookingId'] ?? '').toString(),
      bookingId:
          (data['bookingId'] ?? data['booking_id'] ?? data['id'] ?? '').toString(),
      qrToken: (data['qrToken'] ??
              data['qr_token'] ??
              data['qrCode'] ??
              data['qr_code'] ??
              data['qrCodeImage'] ??
              data['bookingId'] ??
              data['id'] ??
              '')
          .toString(),
      issuedAt: _parseDate(
        data['issuedAt'] ?? data['issued_at'] ?? data['bookingDate'],
      ),
      usedAt: _parseDateOrNull(data['usedAt'] ?? data['used_at']),
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

  static JsonMap _extractData(JsonMap json) {
    final dynamic data = json['data'] ?? json['ticket'] ?? json['item'];
    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value));
    }
    return json;
  }

  static DateTime _parseDate(dynamic value) {
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }

  static DateTime? _parseDateOrNull(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
