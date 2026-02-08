import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:park_ticket/core/network/api_client.dart';
import 'package:park_ticket/features/attraction/data/datasources/attraction_remote_data_source.dart';
import 'package:park_ticket/features/attraction/data/models/attraction_model.dart';

class _MockApiClient extends Mock implements ApiClient {}

ApiException _apiException({
  ApiErrorType type = ApiErrorType.unknown,
  int? status,
}) =>
    ApiException(
      message: 'err',
      type: type,
      statusCode: status,
    );

void main() {
  late _MockApiClient client;
  late AttractionRemoteDataSourceImpl dataSource;

  setUp(() {
    client = _MockApiClient();
    dataSource = AttractionRemoteDataSourceImpl(client);
  });

  group('fetchAttractions', () {
    test('returns parsed list on happy path', () async {
      when(() => client.get('/api/attractions')).thenAnswer(
        (_) async => {
          'data': [
            {'_id': '1', 'name': 'A', 'price': 10},
            {'_id': '2', 'name': 'B', 'price': 20},
          ]
        },
      );

      final result = await dataSource.fetchAttractions();

      expect(result, hasLength(2));
      expect(result.first, isA<AttractionModel>());
    });

    test('ignores non-map items safely', () async {
      when(() => client.get('/api/attractions')).thenAnswer(
        (_) async => {
          'data': [
            {'_id': '1', 'name': 'A'},
            'junk',
          ]
        },
      );

      final result = await dataSource.fetchAttractions();

      expect(result, hasLength(1));
      expect(result.first.id, '1');
    });

    test('falls back on network/unknown', () async {
      when(() => client.get('/api/attractions')).thenThrow(
        _apiException(type: ApiErrorType.network),
      );

      final result = await dataSource.fetchAttractions();

      expect(result, isNotEmpty); // fallback data
    });

    test('rethrows on badResponse', () async {
      when(() => client.get('/api/attractions')).thenThrow(
        _apiException(type: ApiErrorType.badResponse, status: 500),
      );

      expect(
        () => dataSource.fetchAttractions(),
        throwsA(isA<ApiException>()),
      );
    });
  });

  group('fetchAttraction', () {
    test('returns parsed model', () async {
      when(() => client.get('/api/attractions/abc')).thenAnswer(
        (_) async => {
          'data': {'_id': 'abc', 'name': 'One', 'price': 15},
        },
      );

      final result = await dataSource.fetchAttraction('abc');

      expect(result.id, 'abc');
      expect(result.name, 'One');
    });

    test('returns fallback when data empty', () async {
      when(() => client.get('/api/attractions/abc')).thenAnswer(
        (_) async => {},
      );

      final result = await dataSource.fetchAttraction('abc');

      expect(result.id, 'abc');
      expect(result.name, isNotEmpty);
    });

    test('falls back on network/unknown', () async {
      when(() => client.get('/api/attractions/abc')).thenThrow(
        _apiException(type: ApiErrorType.network),
      );

      final result = await dataSource.fetchAttraction('abc');

      expect(result.id, 'abc');
    });

    test('rethrows on badResponse', () async {
      when(() => client.get('/api/attractions/abc')).thenThrow(
        _apiException(type: ApiErrorType.badResponse, status: 404),
      );

      expect(
        () => dataSource.fetchAttraction('abc'),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
