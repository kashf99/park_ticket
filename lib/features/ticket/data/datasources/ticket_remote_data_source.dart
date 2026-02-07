import 'package:flutter/material.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/utils/typedefs.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../booking/data/models/booking_model.dart';
import '../../../booking/domain/entities/booking.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/entities/ticket_record.dart';
import '../models/ticket_model.dart';

abstract class TicketRemoteDataSource {
  Future<TicketModel> fetchTicket(String bookingId);
  Future<List<TicketRecord>> fetchTicketHistory();
}

class TicketRemoteDataSourceImpl implements TicketRemoteDataSource {
  final ApiClient client;
  final LocalStorage storage;
  const TicketRemoteDataSourceImpl(this.client, this.storage);

  @override
  Future<TicketModel> fetchTicket(String bookingId) async {
    final lookupValue = await _resolveVisitorId(bookingId);
    final json = await _fetchBookingsByVisitor(lookupValue);
    debugPrint('Fetch ticket response: $json');
    final items = _extractTicketList(json);
    if (items.isNotEmpty) {
      return TicketModel.fromJson(items.first);
    }
    return TicketModel.fromJson(json);
  }

  @override
  Future<List<TicketRecord>> fetchTicketHistory() async {
    final visitorId = await _resolveVisitorId('');
    if (visitorId.trim().isEmpty) {
      debugPrint('Fetch ticket history skipped: missing visitorId');
      return const [];
    }
    final json = await _fetchBookingsByVisitor(visitorId);
    debugPrint('Fetch ticket history response: $json');
    final items = _extractTicketList(json);
    if (items.isEmpty) {
      return const [];
    }
    return items.map((item) {
      final bookingData = _normalizeMap(item['booking'])..addAll(item);
      final booking = BookingModel.fromJson(bookingData);
      final ticket = _ticketFromMap(
        _normalizeMap(item['ticket'])..addAll(item),
        booking,
      );
      return TicketRecord(booking: booking, ticket: ticket);
    }).toList();
  }

  Map<String, dynamic> _normalizeMap(dynamic value) {
    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), val));
    }
    return <String, dynamic>{};
  }

  List<Map<String, dynamic>> _extractTicketList(JsonMap json) {
    final dynamic data =
        json['data'] ?? json['tickets'] ?? json['items'] ?? json['results'];
    if (data is List) {
      return data.cast<Map<String, dynamic>>();
    }
    if (data is Map) {
      for (final key in ['data', 'bookings', 'tickets', 'items', 'results']) {
        final nested = data[key];
        if (nested is List) {
          return nested.cast<Map<String, dynamic>>();
        }
      }
      return [data.map((key, value) => MapEntry(key.toString(), value))];
    }
    if (json['bookingId'] != null || json['booking_id'] != null) {
      return [json];
    }
    return const [];
  }

  Future<String> _resolveVisitorId(String fallback) async {
    final storedEmail = await storage.getUserEmail();
    if (storedEmail != null && storedEmail.trim().isNotEmpty) {
      return storedEmail.trim();
    }
    final storedPhone = await storage.getUserPhone();
    if (storedPhone != null && storedPhone.trim().isNotEmpty) {
      return storedPhone.trim();
    }
    return fallback;
  }

  Future<JsonMap> _fetchBookingsByVisitor(String visitorId) async {
    debugPrint('Fetching tickets: /api/bookings/visitor/ (POST body)');
    return client.post('/api/bookings/visitor/', {'visitorId': visitorId});
  }

  Ticket _ticketFromMap(Map<String, dynamic> data, Booking booking) {
    final ticketId = (data['ticketId'] ?? data['id'] ?? 'T-${booking.id}')
        .toString();
    final bookingId = (data['bookingId'] ?? data['booking_id'] ?? booking.id)
        .toString();
    final qrToken =
        (data['qrToken'] ??
                data['qr_token'] ??
                data['qrCode'] ??
                data['qr_code'] ??
                booking.id)
            .toString();
    final issuedAt = _parseDate(
      data['issuedAt'] ?? data['issued_at'] ?? booking.visitDate,
    );
    final usedAt = _parseDateOrNull(data['usedAt'] ?? data['used_at']);
    return Ticket(
      id: ticketId,
      bookingId: bookingId,
      qrToken: qrToken,
      issuedAt: issuedAt,
      usedAt: usedAt,
    );
  }

  DateTime _parseDate(dynamic value) {
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }

  DateTime? _parseDateOrNull(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
