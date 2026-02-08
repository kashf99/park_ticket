import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_client.dart';

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(
    baseUrl:"http://10.0.2.2:4000"
    // "https://hcbrb0pp-4000.inc1.devtunnels.ms"
    //'https://reasonable-mollusk-est-25df9ad3.koyeb.app',
  ),
);
