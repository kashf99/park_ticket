import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:park_ticket/core/network/api_client_provider.dart';
import 'package:park_ticket/features/attraction/data/datasources/attraction_remote_data_source.dart';
import 'package:park_ticket/features/attraction/data/repositories/attraction_repository_impl.dart';
import 'package:park_ticket/features/attraction/domain/entities/attraction.dart';
import 'package:park_ticket/features/attraction/domain/repositories/attraction_repository.dart';
import 'package:park_ticket/features/attraction/domain/usecases/get_attraction.dart';
import 'package:park_ticket/features/attraction/domain/usecases/get_attractions.dart';

final attractionRemoteDataSourceProvider = Provider<AttractionRemoteDataSource>(
  (ref) {
    final client = ref.read(apiClientProvider);
    return AttractionRemoteDataSourceImpl(client);
  },
);

final attractionRepositoryProvider = Provider<AttractionRepository>((ref) {
  final remote = ref.read(attractionRemoteDataSourceProvider);
  return AttractionRepositoryImpl(remote);
});

final getAttractionProvider = Provider<GetAttraction>((ref) {
  final repo = ref.read(attractionRepositoryProvider);
  return GetAttraction(repo);
});

final getAttractionsProvider = Provider<GetAttractions>((ref) {
  final repo = ref.read(attractionRepositoryProvider);
  return GetAttractions(repo);
});

final attractionProvider = FutureProvider.family<Attraction, String>((ref, id) {
  return ref.read(getAttractionProvider)(id);
});

final attractionsProvider = FutureProvider<List<Attraction>>((ref) {
  return ref.read(getAttractionsProvider)();
});
