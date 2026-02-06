class Ticket {
  final String id;
  final String bookingId;
  final String qrToken;
  final DateTime issuedAt;
  final DateTime? usedAt;

  const Ticket({
    required this.id,
    required this.bookingId,
    required this.qrToken,
    required this.issuedAt,
    required this.usedAt,
  });
}
