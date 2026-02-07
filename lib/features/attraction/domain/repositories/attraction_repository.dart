import '../entities/attraction.dart';

abstract class AttractionRepository {
  Future<Attraction> getAttraction(String id);
  Future<List<Attraction>> getAttractions();
}
