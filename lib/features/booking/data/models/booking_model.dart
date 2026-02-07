import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/booking.dart';

class BookingModel extends Booking {
  const BookingModel({
    required super.id,
    required super.attractionId,
    required super.visitDate,
    required super.timeSlot,
    required super.quantity,
    required super.name,
    required super.email,
    required super.totalCents,
    required super.status,
    super.qrToken,
    super.attractionName,
    super.totalAmount,
    super.taxAmount,
    super.finalAmount,
    super.paymentReference,
    super.qrCodeImage,
  });

  factory BookingModel.fromJson(JsonMap json) {
    final data = _extractData(json);
    return BookingModel(
      id: (data['bookingId'] ?? data['_id'] ?? data['id'] ?? '').toString(),
      attractionId: (data['attractionId'] ?? data['attraction_id'] ?? '')
          .toString(),
      visitDate: _parseDate(data['bookingDate'] ?? data['visit_date']),
      timeSlot: (data['timeSlot'] ?? data['time_slot'] ?? '').toString(),
      quantity: _parseInt(data['numberOfTickets'] ?? data['quantity'] ?? 0),
      name: (data['visitorName'] ?? data['name'] ?? '').toString(),
      email: (data['visitorEmail'] ?? data['email'] ?? '').toString(),
      totalCents: _parseInt(
        data['finalAmount'] ??
            data['totalAmount'] ??
            data['totalCents'] ??
            data['total_cents'] ??
            data['ticketPrice'] ??
            0,
      ),
      status: (data['bookingStatus'] ?? data['status'] ?? 'confirmed')
          .toString(),
      qrToken: data['qrToken'] as String? ?? data['qr_token'] as String?,
      attractionName: (data['attractionName'] ?? '').toString(),
      totalAmount: _parseInt(data['totalAmount']),
      taxAmount: _parseInt(data['taxAmount']),
      finalAmount: _parseInt(data['finalAmount']),
      paymentReference: (data['paymentReference'] ?? '').toString(),
      qrCodeImage: (data['qrCodeImage'] ?? '').toString(),
    );
  }

  JsonMap toJson() {
    return {
      'id': id,
      'attraction_id': attractionId,
      'visit_date': visitDate.toIso8601String(),
      'time_slot': timeSlot,
      'quantity': quantity,
      'name': name,
      'email': email,
      'total_cents': totalCents,
      'status': status,
      if (qrToken != null) 'qr_token': qrToken,
      if (attractionName != null) 'attraction_name': attractionName,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (taxAmount != null) 'tax_amount': taxAmount,
      if (finalAmount != null) 'final_amount': finalAmount,
      if (paymentReference != null) 'payment_reference': paymentReference,
      if (qrCodeImage != null) 'qr_code_image': qrCodeImage,
    };
  }

  JsonMap toApiJson() {
    return {
      'attractionId': attractionId,
      'bookingDate': _formatDate(visitDate),
      'timeSlot': timeSlot,
      'visitorEmail': email,
      'visitorName': name,
      'phoneNumber': _defaultPhoneNumber,
      'numberOfTickets': quantity,
    };
  }

  static const String _defaultPhoneNumber = '+971503068186';

  static JsonMap _extractData(JsonMap json) {
    final dynamic data = json['data'] ?? json['booking'] ?? json['item'];
    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value));
    }
    return json;
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) {
      try {
        if (value.length == 10) {
          return DateTime.parse('${value}T00:00:00');
        }
        return DateTime.parse(value);
      } catch (_) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
