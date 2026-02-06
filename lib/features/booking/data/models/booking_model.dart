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
  });

  factory BookingModel.fromJson(JsonMap json) {
    return BookingModel(
      id: json['id'] as String,
      attractionId: json['attraction_id'] as String,
      visitDate: DateTime.parse(json['visit_date'] as String),
      timeSlot: json['time_slot'] as String,
      quantity: json['quantity'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      totalCents: json['total_cents'] as int,
      status: json['status'] as String,
      qrToken: json['qr_token'] as String?,
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
    };
  }
}
