import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client_provider.dart';
import '../../data/datasources/attraction_remote_data_source.dart';
import '../../data/repositories/attraction_repository_impl.dart';
import '../../domain/entities/attraction.dart';
import '../../domain/repositories/attraction_repository.dart';
import '../../domain/usecases/get_attraction.dart';

final attractionRemoteDataSourceProvider = Provider<AttractionRemoteDataSource>((ref) {
  final client = ref.read(apiClientProvider);
  return AttractionRemoteDataSourceImpl(client);
});

final attractionRepositoryProvider = Provider<AttractionRepository>((ref) {
  final remote = ref.read(attractionRemoteDataSourceProvider);
  return AttractionRepositoryImpl(remote);
});

final getAttractionProvider = Provider<GetAttraction>((ref) {
  final repo = ref.read(attractionRepositoryProvider);
  return GetAttraction(repo);
});

final attractionProvider = FutureProvider.family<Attraction, String>((ref, id) {
  return ref.read(getAttractionProvider)(id);
});
