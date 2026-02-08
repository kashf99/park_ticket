import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_client.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  const baseUrl = String.fromEnvironment('API_BASE_URL');

  if (baseUrl.isEmpty) {
    throw StateError(
      'API_BASE_URL is not set. Provide it via --dart-define=API_BASE_URL=https://your-api',
    );
  }

  return ApiClient(baseUrl: baseUrl);
});
