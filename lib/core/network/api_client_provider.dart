import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_client.dart';

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(
    baseUrl: 'https://0fnx75nt-4000.inc1.devtunnels.ms',
  ),
);
