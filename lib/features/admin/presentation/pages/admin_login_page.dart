import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_ticket/features/admin/presentation/providers/admin_provider.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_client_provider.dart';
import '../../../../core/storage/local_storage_provider.dart';
import '../../../../core/utils/spacing.dart';
import '../../../../core/widgets/outline_chip_button.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/section_card.dart';
import 'gate_validation_page.dart';


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
                                'Admin Login',
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
                        height: 350.h,
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

  final usernameController = ref.read(adminLoginUsernameControllerProvider);
  final passwordController = ref.read(adminLoginPasswordControllerProvider);
  ref.read(adminLoginLoadingProvider.notifier).state = true;
  try {
    final apiClient = ref.read(apiClientProvider);
    final storage = ref.read(localStorageProvider);
    final email = usernameController.text.trim();
    final password = passwordController.text;

    final response = await apiClient.post('/api/users/login', {
      'email': email,
      'password': password,
    });

    final token = response['token']?.toString();
    final user = response['user'];
    if (token == null || token.isEmpty || user is! Map) {
      throw const ApiException(
        message: 'Invalid login response',
        type: ApiErrorType.invalidResponse,
        path: '/api/users/login',
      );
    }

    await storage.saveAdminSession(
      token: token,
      name: user['name']?.toString(),
      email: user['email']?.toString(),
      role: user['role']?.toString(),
    );

    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Login successful')));
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const GateValidationPage()),
    );
  } on ApiException catch (error) {
    _showLoginError(context, error);
  } catch (error) {
    debugPrint('Admin login navigation error: $error');
    _showLoginError(context, error);
  } finally {
    if (context.mounted) {
      ref.read(adminLoginLoadingProvider.notifier).state = false;
    }
  }
}

void _showLoginError(BuildContext context, Object error) {
  final message = switch (error) {
    ApiException apiErr =>
      _extractMessage(apiErr) ??
          (apiErr.type == ApiErrorType.network
              ? 'Network error. Check your connection and try again.'
              : 'Login failed. Please try again.'),
    _ => 'Login failed. Please try again.',
  };

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

String? _extractMessage(ApiException error) {
  final data = error.data;
  if (data is Map) {
    final msg = data['message'] ?? data['error'] ?? data['detail'];
    if (msg is String && msg.trim().isNotEmpty) return msg;
  }
  if (data is String && data.trim().isNotEmpty) return data;
  return null;
}
