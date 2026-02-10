import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adminLoginObscureProvider = StateProvider.autoDispose<bool>(
  (ref) => true,
);
final adminLoginLoadingProvider = StateProvider.autoDispose<bool>(
  (ref) => false,
);
final adminLoginFormKeyProvider = Provider.autoDispose<GlobalKey<FormState>>(
  (ref) => GlobalKey<FormState>(),
);
final adminLoginUsernameControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
      final controller = TextEditingController();
      ref.onDispose(controller.dispose);
      return controller;
    });
final adminLoginPasswordControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
      final controller = TextEditingController();
      ref.onDispose(controller.dispose);
      return controller;
    });
