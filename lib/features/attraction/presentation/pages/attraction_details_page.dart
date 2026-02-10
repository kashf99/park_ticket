import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:park_ticket/features/attraction/presentation/widgets/attraction_content.dart';
import 'package:park_ticket/features/attraction/presentation/widgets/attraction_error.dart';

import '../../domain/entities/attraction.dart';
import 'package:park_ticket/features/attraction/di/attraction_di.dart';

class AttractionDetailsPage extends ConsumerWidget {
  const AttractionDetailsPage({
    super.key,
    this.attractionId = '1',
    this.attraction,
  });

  final String attractionId;
  final Attraction? attraction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    Widget buildBody(Widget child) {
      return Expanded(child: child);
    }

    if (attraction != null) {
      return Scaffold(
        body: SafeArea(
          child: buildBody(AttractionContent(attraction: attraction!)),
        ),
      );
    }

    final attractionAsync = ref.watch(attractionProvider(attractionId));

    return Scaffold(
      body: SafeArea(
        child: attractionAsync.when(
          data: (attraction) => buildBody(AttractionContent(attraction: attraction)),
          loading: () => buildBody(const Center(child: CircularProgressIndicator())),
          error: (error, stackTrace) => buildBody(
            AttractionError(
              message: error.toString(),
              onRetry: () => ref.refresh(attractionProvider(attractionId)),
            ),
          ),
        ),
      ),
    );
  }
}
