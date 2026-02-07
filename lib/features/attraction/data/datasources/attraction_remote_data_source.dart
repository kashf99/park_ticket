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
      final json = await client.get('/api/attractions/$id', {});
      final data = _extractAttraction(json);
      if (data.isEmpty) {
        return _fallbackAttraction(id);
      }
      return AttractionModel.fromJson(data);
    } on ApiException catch (error) {
      if (error.type == ApiErrorType.unknown) {
        return _fallbackAttraction(id);
      }
      rethrow;
    }
  }

  @override
  Future<List<AttractionModel>> fetchAttractions() async {
    try {
      final json = await client.get('/api/attractions', {});
      debugPrint('Attractions response keys: ${json.keys.toList()}');
      final rawList = _extractAttractionList(json);
      debugPrint('Attractions list size: ${rawList.length}');
      if (rawList.isEmpty) {
        return _fallbackAttractions();
      }
      return rawList.map((item) => AttractionModel.fromJson(item)).toList();
    } on ApiException catch (error) {
      debugPrint('Attractions API error: $error');
      if (error.type == ApiErrorType.unknown ||
          error.type == ApiErrorType.network ||
          error.type == ApiErrorType.invalidResponse ||
          (error.type == ApiErrorType.badResponse && error.statusCode == 404)) {
        return _fallbackAttractions();
      }
      rethrow;
    }
  }

  AttractionModel _fallbackAttraction(String id) {
    return AttractionModel(
      id: id,
      name: 'Dubai Frame',
      description:
          'Details are temporarily unavailable. Please check back soon.',
      openingTime: '09:00 AM',
      closingTime: '06:00 PM',
      price: 50,
      featuredImage:
          'https://img.freepik.com/premium-photo/13-january-2023-uae-dubai-dubai-frame-striking-gold-color-impressive-height-it-is-mustsee-attraction-anyone-visiting-city_984126-44.jpg?semt=ais_hybrid&w=740&q=80',
    );
  }

  List<Map<String, dynamic>> _extractAttractionList(JsonMap json) {
    final dynamic data =
        json['data'] ?? json['results'] ?? json['items'] ?? json['attractions'];
    if (data is List) {
      return data.cast<Map<String, dynamic>>();
    }
    if (data is Map && data['data'] is List) {
      return (data['data'] as List).cast<Map<String, dynamic>>();
    }
    return const [];
  }

  JsonMap _extractAttraction(JsonMap json) {
    final dynamic data = json['data'] ?? json['attraction'] ?? json['item'];
    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value));
    }
    return json;
  }

  List<AttractionModel> _fallbackAttractions() {
    return const [
      AttractionModel(
        id: '1',
        name: 'Emerald Lake',
        description:
            'Crystal-clear waters surrounded by alpine peaks and pine forests.',
        openingTime: '08:00 AM',
        closingTime: '06:00 PM',
        price: 40,
        featuredImage:
            'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1200&q=80',
      ),
      AttractionModel(
        id: '2',
        name: 'Skyline Viewpoint',
        description:
            'A panoramic city overlook with sunset views and photo spots.',
        openingTime: '09:00 AM',
        closingTime: '09:00 PM',
        price: 30,
        featuredImage:
            'https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=1200&q=80',
      ),
      AttractionModel(
        id: '3',
        name: 'Riverside Market',
        description:
            'Local street food, artisan stalls, and live music by the river.',
        openingTime: '10:00 AM',
        closingTime: '11:00 PM',
        price: 20,
        featuredImage:
            'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',
      ),
      AttractionModel(
        id: '4',
        name: 'Heritage Museum',
        description:
            'Interactive exhibits celebrating culture, art, and history.',
        openingTime: '09:00 AM',
        closingTime: '05:00 PM',
        price: 25,
        featuredImage:
            'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=1200&q=80',
      ),
    ];
  }
}
