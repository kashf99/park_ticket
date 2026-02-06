import 'package:flutter/material.dart';

class ScannerError extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ScannerError({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry Camera'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
