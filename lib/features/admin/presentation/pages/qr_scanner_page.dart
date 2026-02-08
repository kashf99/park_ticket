import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:park_ticket/features/admin/presentation/providers/gate_validation_provider.dart';
import 'package:park_ticket/features/admin/presentation/widgets/scanner_error.dart';

class QrScannerPage extends ConsumerWidget {
  const QrScannerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(qrScannerControllerProvider);
    final started = ref.watch(qrScannerStartedProvider);
    final startError = ref.watch(qrScannerStartErrorProvider);
    final validator = ref.read(gateValidationControllerProvider.notifier);

    ensureScannerStarted(ref, controller);

    Future<void> onDetect(BarcodeCapture capture) async {
      if (ref.read(qrScannerHasScannedProvider)) return;
      if (capture.barcodes.isEmpty) return;
      final value = capture.barcodes.first.rawValue;
      if (value == null || value.trim().isEmpty) return;
      debugPrint('QR detected: ${value.trim()}');

      ref.read(qrScannerHasScannedProvider.notifier).state = true;
      if (!context.mounted) return;

      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) =>
            const Center(child: CircularProgressIndicator(color: Colors.white)),
      );

      try {
        await validator.validate(value.trim());
      } catch (error) {
        debugPrint('QR validation error: $error');
      }
      if (!context.mounted) return;
      final validationState = ref.read(gateValidationControllerProvider);
      Navigator.of(context).pop();

      final isValid = validationState.result?.isValid ?? false;
      final message =
          validationState.result?.message ??
          validationState.errorMessage ??
          'Failed to validate the ticket.';

      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(isValid ? 'Ticket Validated' : 'Validation Failed'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (!context.mounted) return;

      if (isValid) {
        Navigator.of(context).pop(value.trim());
      } else {
        ref.read(qrScannerHasScannedProvider.notifier).state = false;
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: MobileScanner(
                controller: controller,
                fit: BoxFit.cover,
                onDetect: onDetect,
                errorBuilder: (context, error, child) {
                  debugPrint('QR scanner error: $error');
                  final message = switch (error.errorCode) {
                    MobileScannerErrorCode.permissionDenied =>
                      'Camera permission denied. Enable it in Settings.',
                    MobileScannerErrorCode.unsupported =>
                      'Camera not supported on this device.',
                    MobileScannerErrorCode.controllerUninitialized =>
                      'Camera not ready yet. Try again.',
                    _ => 'Unable to start camera. Try again.',
                  };

                  return ScannerError(message: message);
                },
              ),
            ),
            if (!started && startError == null)
              const Positioned.fill(
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            if (startError != null)
              Positioned.fill(
                child: ScannerError(
                  message: 'Camera failed to start.\n$startError',
                  onRetry: () async {
                    ref.read(qrScannerStartedProvider.notifier).state = false;
                    ref.read(qrScannerStartErrorProvider.notifier).state = null;
                    try {
                      await controller.stop();
                      await controller.start();
                    } catch (error) {
                      debugPrint('QR scanner retry error: $error');
                      rethrow;
                    }
                  },
                ),
              ),
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Scan QR code',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Align the QR code within the frame to scan.',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
