import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/attraction.dart';

class AttractionModel extends Attraction {
  const AttractionModel({
    required super.id,
    required super.name,
    required super.description,
    required super.openingTime,
    required super.closingTime,
    required super.price,
    required super.featuredImage,
  });

  factory AttractionModel.fromJson(JsonMap json) {
    final data = _extractData(json);
    return AttractionModel(
      id: (data['_id'] ?? data['id'] ?? '').toString(),
      name: (data['name'] ?? 'Attraction').toString(),
      description: (data['description'] ?? '').toString(),
      openingTime: _pickTime(data, 'opening_time', 'openingTime', 'opening'),
      closingTime: _pickTime(data, 'closing_time', 'closingTime', 'closing'),
      price: _parseInt(
        data['ticketPrice'] ?? data['price_cents'] ?? data['price'] ?? 0,
      ),
      featuredImage: (data['imageUrl'] ??
              data['featured_image'] ??
              data['featuredImage'] ??
              '')
          .toString(),
    );
  }

  JsonMap toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'opening_time': openingTime,
      'closing_time': closingTime,
      'price_cents': price,
      'featured_image': featuredImage,
    };
  }

  static JsonMap _extractData(JsonMap json) {
    final dynamic data = json['data'] ?? json['attraction'] ?? json['item'];
    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value));
    }
    return json;
  }

  static String _pickTime(
    Map data,
    String snakeKey,
    String camelKey,
    String timingsKey,
  ) {
    final dynamic timings = data['timings'];
    final dynamic fromTimings =
        timings is Map ? timings[timingsKey] ?? timings[timingsKey.toLowerCase()] : null;
    final value = data[snakeKey] ?? data[camelKey] ?? fromTimings ?? '';
    final text = value?.toString().trim() ?? '';
    if (text.isEmpty) {
      return timingsKey == 'opening' ? '09:00 AM' : '06:00 PM';
    }
    return text;
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
