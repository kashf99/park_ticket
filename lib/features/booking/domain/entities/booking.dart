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
  });
}
