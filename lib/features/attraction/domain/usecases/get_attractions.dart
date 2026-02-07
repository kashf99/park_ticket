import '../entities/attraction.dart';
import '../repositories/attraction_repository.dart';

class GetAttractions {
  final AttractionRepository repository;
  const GetAttractions(this.repository);

  Future<List<Attraction>> call() {
    return repository.getAttractions();
  }
}
