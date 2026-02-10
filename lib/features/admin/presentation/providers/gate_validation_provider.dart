import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:park_ticket/core/network/api_client.dart';
import 'package:park_ticket/features/admin/presentation/pages/qr_scanner_page.dart';

import '../../domain/entities/validation_result.dart';
import 'package:park_ticket/features/admin/di/admin_di.dart';

class GateValidationState {
  final bool isLoading;
  final ValidationResult? result;
  final String? errorMessage;

  const GateValidationState({
    required this.isLoading,
    required this.result,
    required this.errorMessage,
  });

  factory GateValidationState.initial() {
    return const GateValidationState(
      isLoading: false,
      result: null,
      errorMessage: null,
    );
  }

  GateValidationState copyWith({
    bool? isLoading,
    ValidationResult? result,
    String? errorMessage,
    bool clearResult = false,
    bool clearError = false,
  }) {
    return GateValidationState(
      isLoading: isLoading ?? this.isLoading,
      result: clearResult ? null : (result ?? this.result),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

enum GateValidationMode { scan, createAttraction }

class GateValidationController
    extends AutoDisposeNotifier<GateValidationState> {
  @override
  GateValidationState build() => GateValidationState.initial();

  void clearMessages() {
    state = state.copyWith(clearResult: true, clearError: true);
  }

  void setEmptyTokenError() {
    state = state.copyWith(
      errorMessage: 'Enter or scan a QR code.',
      clearResult: true,
    );
  }

  Future<void> validate(String token) async {
    if (token.trim().isEmpty) {
      setEmptyTokenError();
      return;
    }

    state = state.copyWith(
      isLoading: true,
      clearResult: true,
      clearError: true,
    );
    try {
      final validation = await ref.read(validateTicketProvider)(token.trim());
      state = state.copyWith(result: validation);
    } on ApiException catch (error) {
      debugPrint('GateValidation error: $error');
      final backendMessage = _extractBackendMessage(error);
      final message = backendMessage ??
          (error.type == ApiErrorType.unknown
              ? 'Check your connection and try again.'
              : 'Unable to validate this ticket right now.');
      state = state.copyWith(errorMessage: message);
    } catch (error) {
      debugPrint('GateValidation error: $error');
      state = state.copyWith(
        errorMessage: 'Unable to validate this ticket right now.',
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

String? _extractBackendMessage(ApiException error) {
  final data = error.data;
  if (data is Map) {
    final message = data['message'] ?? data['error'] ?? data['detail'];
    if (message is String && message.trim().isNotEmpty) {
      return message;
    }
  }
  if (data is String && data.trim().isNotEmpty) {
    return data;
  }
  return null;
}

final gateValidationControllerProvider =
    AutoDisposeNotifierProvider<GateValidationController, GateValidationState>(
      GateValidationController.new,
    );

final gateValidationModeProvider =
    StateProvider.autoDispose<GateValidationMode>(
      (ref) => GateValidationMode.scan,
    );

final gateValidationQrControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
      final controller = TextEditingController();
      ref.onDispose(controller.dispose);
      return controller;
    });

final qrScannerHasScannedProvider = StateProvider.autoDispose<bool>(
  (ref) => false,
);
final qrScannerStartedProvider = StateProvider.autoDispose<bool>(
  (ref) => false,
);
final qrScannerStartErrorProvider = StateProvider.autoDispose<String?>(
  (ref) => null,
);

final qrScannerControllerProvider =
    Provider.autoDispose<MobileScannerController>((ref) {
      final controller = MobileScannerController(
        autoStart: false,
        facing: CameraFacing.back,
        detectionSpeed: DetectionSpeed.noDuplicates,
        formats: const [BarcodeFormat.qrCode],
      );
      ref.onDispose(controller.dispose);
      return controller;
    });

Future<String?> openQrScanner(BuildContext context) {
  return Navigator.of(context).push<String>(
    MaterialPageRoute<String>(
      builder: (_) => const QrScannerPage(),
      fullscreenDialog: true,
    ),
  );
}

void ensureScannerStarted(WidgetRef ref, MobileScannerController controller) {
  if (ref.read(qrScannerStartedProvider)) return;
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    if (ref.read(qrScannerStartedProvider)) return;
    try {
      await controller.start();
      ref.read(qrScannerStartErrorProvider.notifier).state = null;
    } catch (error) {
      ref.read(qrScannerStartErrorProvider.notifier).state = error.toString();
    } finally {
      ref.read(qrScannerStartedProvider.notifier).state = true;
    }
  });
}
