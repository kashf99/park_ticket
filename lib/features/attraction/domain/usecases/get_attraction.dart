import '../entities/attraction.dart';
import '../repositories/attraction_repository.dart';

class GetAttraction {
  final AttractionRepository repository;
  const GetAttraction(this.repository);

  Future<Attraction> call(String id) {
    return repository.getAttraction(id);
  }
}
