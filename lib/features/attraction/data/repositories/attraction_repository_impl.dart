import '../../domain/entities/attraction.dart';
import '../../domain/repositories/attraction_repository.dart';
import '../datasources/attraction_remote_data_source.dart';

class AttractionRepositoryImpl implements AttractionRepository {
  final AttractionRemoteDataSource remote;
  const AttractionRepositoryImpl(this.remote);

  @override
  Future<Attraction> getAttraction(String id) {
    return remote.fetchAttraction(id);
  }

  @override
  Future<List<Attraction>> getAttractions() {
    return remote.fetchAttractions();
  }
}
