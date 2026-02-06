import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:park_ticket/features/attraction/presentation/widgets/attraction_content.dart';
import 'package:park_ticket/features/attraction/presentation/widgets/attraction_error.dart';

import '../providers/attraction_provider.dart';

class AttractionPage extends ConsumerWidget {
  const AttractionPage({super.key, this.attractionId = '1'});

  final String attractionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attractionAsync = ref.watch(attractionProvider(attractionId));

    return Scaffold(
      body: SafeArea(
        child: attractionAsync.when(
          data: (attraction) => AttractionContent(
            attraction: attraction,
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => AttractionError(
            message: error.toString(),
            onRetry: () => ref.refresh(attractionProvider(attractionId)),
          ),
        ),
      ),
    );
  }
}
