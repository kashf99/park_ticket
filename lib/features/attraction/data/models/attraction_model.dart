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
    return AttractionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      openingTime: json['opening_time'] as String,
      closingTime: json['closing_time'] as String,
      price: json['price_cents'] as int,
      featuredImage: json['featured_image'] as String,
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
}
