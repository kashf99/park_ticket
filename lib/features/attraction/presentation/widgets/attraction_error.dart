import 'package:flutter/material.dart';
import 'package:park_ticket/core/utils/spacing.dart';
import 'package:park_ticket/core/widgets/primary_button.dart';

class AttractionError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const AttractionError({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Unable to load attraction',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            vSpaceS,
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            vSpaceM,
            PrimaryButton(
              label: 'Try Again',
              trailingIcon: Icons.refresh,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
