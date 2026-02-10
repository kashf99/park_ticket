import 'package:flutter/foundation.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/utils/typedefs.dart';
import '../models/attraction_model.dart';

abstract class AttractionRemoteDataSource {
  Future<AttractionModel> fetchAttraction(String id);
  Future<List<AttractionModel>> fetchAttractions();
}

class AttractionRemoteDataSourceImpl implements AttractionRemoteDataSource {
  final ApiClient client;
  const AttractionRemoteDataSourceImpl(this.client);

  @override
  Future<AttractionModel> fetchAttraction(String id) async {
    try {
      final json = await client.get('/api/attractions/$id');
      final data = _extractAttraction(json);
      if (data.isEmpty) {
        throw ApiException(
          message: 'Attraction data not available.',
          type: ApiErrorType.invalidResponse,
          path: '/api/attractions/$id',
          data: json,
        );
      }
      return AttractionModel.fromJson(data);
    } on ApiException catch (error) {
      debugPrint('Attraction detail API error: $error');
      rethrow;
    }
  }

  @override
  Future<List<AttractionModel>> fetchAttractions() async {
    try {
      final json = await client.get('/api/attractions');
      debugPrint('Attractions raw response: $json');
      debugPrint('Attractions response keys: ${json.keys.toList()}');
      final rawList = _extractAttractionList(json);
      debugPrint('Attractions list size: ${rawList.length}');
      for (var i = 0; i < rawList.length; i++) {
        debugPrint('Attraction[$i]: ${rawList[i]}');
      }
      if (rawList.isEmpty) {
        // No data returned from API; surface empty state instead of demo list.
        return const [];
      }
      return rawList.map((item) => AttractionModel.fromJson(item)).toList();
    } on ApiException catch (error) {
      debugPrint('Attractions API error: $error');
      rethrow;
    }
  }

  List<Map<String, dynamic>> _extractAttractionList(JsonMap json) {
    final dynamic data =
        json['data'] ?? json['results'] ?? json['items'] ?? json['attractions'];
    if (data is List) {
      return data
          .whereType<Map>()
          .map((item) => item.map((k, v) => MapEntry(k.toString(), v)))
          .toList(growable: false);
    }
    if (data is Map && data['data'] is List) {
      return (data['data'] as List)
          .whereType<Map>()
          .map((item) => item.map((k, v) => MapEntry(k.toString(), v)))
          .toList(growable: false);
    }
    return const [];
  }

  JsonMap _extractAttraction(JsonMap json) {
    final dynamic data = json['data'] ?? json['attraction'] ?? json['item'];
    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value));
    }
    return <String, dynamic>{};
  }

}
