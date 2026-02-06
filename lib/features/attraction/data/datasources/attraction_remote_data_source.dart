import '../../../../core/network/api_client.dart';
import '../models/attraction_model.dart';

abstract class AttractionRemoteDataSource {
  Future<AttractionModel> fetchAttraction(String id);
}

class AttractionRemoteDataSourceImpl implements AttractionRemoteDataSource {
  final ApiClient client;
  const AttractionRemoteDataSourceImpl(this.client);

  @override
  Future<AttractionModel> fetchAttraction(String id) async {
    try {
      final json = await client.get('/attractions/$id');
      if (json.isEmpty) {
        return _fallbackAttraction(id);
      }
      return AttractionModel.fromJson(json);
    } on ApiException catch (error) {
      if (error.type == ApiErrorType.unknown) {
        return _fallbackAttraction(id);
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
}
