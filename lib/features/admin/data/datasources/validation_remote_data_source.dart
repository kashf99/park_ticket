import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../../core/network/api_client.dart';
import '../models/validation_result_model.dart';

abstract class ValidationRemoteDataSource {
  Future<ValidationResultModel> validateTicket(String qrToken);
}

class ValidationRemoteDataSourceImpl implements ValidationRemoteDataSource {
  final ApiClient client;
  const ValidationRemoteDataSourceImpl(this.client);

  @override
  Future<ValidationResultModel> validateTicket(String qrToken) async {
    final payload = _buildPayload(qrToken);
    debugPrint('Validate QR payload: $payload');
    final json = await client.post('/api/bookings/validate-qr', payload);
    debugPrint('Validate QR response: $json');
    return ValidationResultModel.fromJson(json);
  }

  Map<String, dynamic> _buildPayload(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return {'bookingId': '', 'visitorEmail': '', 'hash': ''};
    }

    final queryLike = _parseQueryLike(trimmed);
    if (queryLike.isNotEmpty) {
      final qr =
          queryLike['qrToken'] ??
          queryLike['hash'] ??
          queryLike['token'] ??
          trimmed;
      return {
        'bookingId': queryLike['bookingId'] ?? queryLike['booking_id'] ?? '',
        'visitorEmail':
            queryLike['visitorEmail'] ?? queryLike['visitor_email'] ?? '',
        'hash': qr,
        'qrToken': qr,
      };
    }

    if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
      try {
        final decoded = jsonDecode(trimmed);
        if (decoded is Map) {
          final qr =
              decoded['qrToken'] ??
              decoded['qr_token'] ??
              decoded['hash'] ??
              trimmed;
          return {
            'bookingId':
                decoded['bookingId'] ??
                decoded['booking_id'] ??
                decoded['id'] ??
                '',
            'visitorEmail':
                decoded['visitorEmail'] ??
                decoded['visitor_email'] ??
                decoded['email'] ??
                '',
            'hash': qr,
            'qrToken': qr,
          };
        }
      } catch (_) {}
    }

    if (trimmed.contains('|')) {
      final parts = trimmed.split('|');
      if (parts.length >= 3) {
        final qr = parts.sublist(2).join('|');
        return {
          'bookingId': parts[0],
          'visitorEmail': parts[1],
          'hash': qr,
          'qrToken': qr,
        };
      }
      if (parts.length == 2) {
        final qr = parts[1];
        return {
          'bookingId': parts[0],
          'visitorEmail': '',
          'hash': qr,
          'qrToken': qr,
        };
      }
    }

    // Fallback: treat the input as both bookingId and qr token so validation
    // endpoint receives a usable value regardless of what the user typed.
    return {
      'bookingId': trimmed,
      'visitorEmail': '',
      'hash': trimmed,
      'qrToken': trimmed,
    };
  }

  Map<String, String> _parseQueryLike(String value) {
    if (!value.contains('=')) return const {};
    final segments = value.split('&');
    final map = <String, String>{};
    for (final segment in segments) {
      final parts = segment.split('=');
      if (parts.length < 2) continue;
      final key = parts.first.trim();
      final val = parts.sublist(1).join('=').trim();
      if (key.isEmpty) continue;
      map[key] = val;
    }
    return map;
  }
}
