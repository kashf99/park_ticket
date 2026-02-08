import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:park_ticket/core/network/api_client.dart';
import 'package:park_ticket/features/admin/data/datasources/validation_remote_data_source.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  late _MockApiClient client;
  late ValidationRemoteDataSourceImpl dataSource;

  setUp(() {
    client = _MockApiClient();
    dataSource = ValidationRemoteDataSourceImpl(client);
  });

  test('builds payload from query-like token', () async {
    when(() => client.post(any(), any())).thenAnswer(
      (_) async => {'data': {'isValid': true, 'message': 'ok'}},
    );

    await dataSource.validateTicket('bookingId=1&visitorEmail=a@b.com&hash=xyz');

    verify(() => client.post('/api/bookings/validate-qr', any())).called(1);
  });

  test('builds payload from plain token', () async {
    when(() => client.post(any(), any())).thenAnswer(
      (_) async => {'data': {'isValid': true, 'message': 'ok'}},
    );

    await dataSource.validateTicket('plain-token');

    final captured = verify(() => client.post('/api/bookings/validate-qr', captureAny())).captured;
    expect((captured.first as Map)['hash'], 'plain-token');
  });
}
