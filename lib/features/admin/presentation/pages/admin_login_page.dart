import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/spacing.dart';
import '../../../../core/widgets/outline_chip_button.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/section_card.dart';
import 'gate_validation_page.dart';

final adminLoginObscureProvider = StateProvider.autoDispose<bool>((ref) => true);
final adminLoginLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);
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

class AdminLoginPage extends ConsumerWidget {
  const AdminLoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isObscured = ref.watch(adminLoginObscureProvider);
    final isLoading = ref.watch(adminLoginLoadingProvider);
    final formKey = ref.watch(adminLoginFormKeyProvider);
    final usernameController = ref.watch(adminLoginUsernameControllerProvider);
    final passwordController = ref.watch(adminLoginPasswordControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth < 500 ? 16.0 : 28.0;
            final contentWidth = constraints.maxWidth > 720
                ? 720.0
                : constraints.maxWidth;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 20,
              ),
              child: Center(
                child: SizedBox(
                  width: contentWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Admin',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: AppColors.inkMuted,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Text(
                                'Gate Admin Login',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineMedium,
                              ),
                            ],
                          ),
                          OutlineChipButton(
                            label: 'Back',
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                      vSpaceM,
                      SectionCard(
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sign in to continue',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              vSpaceS,
                              Text(
                                'Use your admin credentials to access gate validation.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              vSpaceM,
                              TextFormField(
                                controller: usernameController,
                                decoration: const InputDecoration(
                                  labelText: 'Username or Email',
                                  prefixIcon: Icon(Icons.person_outline),
                                ),
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Enter your username';
                                  }
                                  return null;
                                },
                              ),
                              vSpaceM,
                              TextFormField(
                                controller: passwordController,
                                obscureText: isObscured,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      isObscured
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      ref
                                              .read(
                                                adminLoginObscureProvider
                                                    .notifier,
                                              )
                                              .state =
                                          !isObscured;
                                    },
                                  ),
                                ),
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) =>
                                    _submit(context, ref, formKey),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Enter your password';
                                  }
                                  return null;
                                },
                              ),
                              vSpaceM,
                              Align(
                                alignment: Alignment.centerRight,
                                child: PrimaryButton(
                                  label: isLoading ? 'Logging in...' : 'Login',
                                  trailingIcon: Icons.arrow_forward,
                                  onPressed: isLoading
                                      ? null
                                      : () => _submit(context, ref, formKey),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Future<void> _submit(
  BuildContext context,
  WidgetRef ref,
  GlobalKey<FormState> formKey,
) async {
  if (ref.read(adminLoginLoadingProvider)) {
    return;
  }
  final form = formKey.currentState;
  if (form == null || !form.validate()) {
    return;
  }

  ref.read(adminLoginLoadingProvider.notifier).state = true;
  try {
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const GateValidationPage()),
    );
  } catch (error) {
    debugPrint('Admin login navigation error: $error');
  } finally {
    if (context.mounted) {
      ref.read(adminLoginLoadingProvider.notifier).state = false;
    }
  }
}
