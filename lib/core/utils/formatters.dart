String formatTime(String value) {
  if (value.trim().isEmpty) return '--';
  return value;
}

String formatPrice(int priceCents) {
  final text = priceCents % 1 == 0
      ? priceCents.toStringAsFixed(0)
      : priceCents.toStringAsFixed(2);
  return '$text AED';
}

String formatBookingId(String bookingId, {int visibleCount = 12}) {
  final trimmed = bookingId.trim();
  if (trimmed.isEmpty) return '--';
  if (trimmed.length <= visibleCount) return trimmed;
  return '${trimmed.substring(0, visibleCount)}...';
}

String formatShortDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final month = months[date.month - 1];
  return '$month ${date.day}';
}
