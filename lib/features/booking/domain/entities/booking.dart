class Booking {
  final String id;
  final String attractionId;
  final DateTime visitDate;
  final String timeSlot;
  final int quantity;
  final String name;
  final String email;
  final int totalCents;
  final String status;
  final String? qrToken;
  final String? attractionName;
  final int? totalAmount;
  final int? taxAmount;
  final int? finalAmount;
  final String? paymentReference;
  final String? qrCodeImage;

  const Booking({
    required this.id,
    required this.attractionId,
    required this.visitDate,
    required this.timeSlot,
    required this.quantity,
    required this.name,
    required this.email,
    required this.totalCents,
    required this.status,
    this.qrToken,
    this.attractionName,
    this.totalAmount,
    this.taxAmount,
    this.finalAmount,
    this.paymentReference,
    this.qrCodeImage,
  });
}
