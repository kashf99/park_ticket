import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:park_ticket/core/network/api_client.dart';
import 'package:park_ticket/core/network/api_client_provider.dart';
import 'package:park_ticket/core/storage/local_storage_provider.dart';
import 'package:park_ticket/core/theme/app_colors.dart';
import 'package:park_ticket/core/utils/spacing.dart';
import 'package:park_ticket/core/widgets/app_shell.dart';
import 'package:park_ticket/core/widgets/outline_chip_button.dart';
import 'package:park_ticket/core/widgets/primary_button.dart';
import 'package:park_ticket/features/admin/presentation/providers/gate_validation_provider.dart';
import 'package:park_ticket/features/attraction/presentation/providers/attraction_provider.dart';

class GateValidationPage extends ConsumerWidget {
  const GateValidationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(gateValidationQrControllerProvider);
    final state = ref.watch(gateValidationControllerProvider);
    final notifier = ref.read(gateValidationControllerProvider.notifier);
    final mode = ref.watch(gateValidationModeProvider);

    Future<void> openScanner() async {
      ref.read(qrScannerHasScannedProvider.notifier).state = false;
      final token = await openQrScanner(context);
      if (token != null && token.trim().isNotEmpty) {
        controller.text = token.trim();
      }
    }



    void goHome() {
      // Return to main bottom-nav screen (tab 0) and unwind the stack.
      ref.read(appTabIndexProvider.notifier).state = 0;
      final navigator = Navigator.of(context);
      if (navigator.canPop()) {
        navigator.popUntil((route) => route.isFirst);
      } else {
        navigator.pushReplacement(
          MaterialPageRoute<void>(builder: (_) => const AppShell()),
        );
      }
    }

    return WillPopScope(
      onWillPop: () async {
        goHome();
        return false;
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final horizontalPadding = constraints.maxWidth < 500
                    ? 16.0
                    : 28.0;
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
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Admin',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppColors.inkMuted,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Text(
                                      'Gate Validation',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.headlineMedium,
                                    ),
                                  ],
                                ),
                              ),

                              hSpaceS,
                              OutlineChipButton(
                                label: 'Back',
                                onPressed: goHome,
                              ),
                            ],
                          ),
                          vSpaceM,
                          _ModeToggle(
                            mode: mode,
                            onChanged: (nextMode) {
                              ref
                                      .read(gateValidationModeProvider.notifier)
                                      .state =
                                  nextMode;
                              notifier.clearMessages();
                            },
                          ),
                          vSpaceM,
                          if (mode == GateValidationMode.createAttraction)
                            const _NewAttractionForm(),
                          if (mode == GateValidationMode.scan)
                            _ScanCard(onActivate: openScanner),
                          if (state.errorMessage != null) ...[
                            vSpaceM,
                            _ValidationMessage(
                              message: state.errorMessage!,
                              isSuccess: false,
                            ),
                          ],
                          if (state.result != null) ...[
                            vSpaceM,
                            _ValidationMessage(
                              message: state.result!.message,
                              isSuccess: state.result!.isValid,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeToggle extends StatelessWidget {
  final GateValidationMode mode;
  final ValueChanged<GateValidationMode> onChanged;

  const _ModeToggle({required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2F6),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.outline),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _ModeChip(
              icon: Icons.qr_code_scanner,
              label: 'Scan QR',
              selected: mode == GateValidationMode.scan,
              onTap: () => onChanged(GateValidationMode.scan),
            ),
          ),
          hSpaceS,
          Expanded(
            child: _ModeChip(
              icon: Icons.text_fields,
              label: 'New Attraction',
              selected: mode == GateValidationMode.createAttraction,
              onTap: () => onChanged(GateValidationMode.createAttraction),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeChip({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = selected ? AppColors.ink : AppColors.inkMuted;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        boxShadow: selected
            ? const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: textColor),
              hSpaceS,
              Flexible(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SoftCard extends StatelessWidget {
  final Widget child;

  const _SoftCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.outline),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 28,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _NewAttractionForm extends ConsumerStatefulWidget {
  const _NewAttractionForm();

  @override
  ConsumerState<_NewAttractionForm> createState() => _NewAttractionFormState();
}

class _NewAttractionFormState extends ConsumerState<_NewAttractionForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _openingController = TextEditingController(text: '09:00 AM');
  final _closingController = TextEditingController(text: '06:00 PM');
  final _locationController = TextEditingController(text: 'Main Zone');
  final _priceController = TextEditingController(text: '25.50');
  final _capacityController = TextEditingController(text: '40');
  final List<String> _timeOptions = List.generate(24, (index) {
    final hour = index % 12 == 0 ? 12 : index % 12;
    final suffix = index < 12 ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:00 $suffix';
  });
  String? _imagePath;
  bool _isActive = true;
  bool _isSubmitting = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _openingController.dispose();
    _closingController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await _picker.pickImage(source: ImageSource.gallery);
    if (result != null) {
      setState(() => _imagePath = result.path);
    }
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final apiClient = ref.read(apiClientProvider);
    final storage = ref.read(localStorageProvider);
    final token = await storage.getAdminToken();
    if (token == null || token.isEmpty) {
      _showSnack('Admin session missing. Please log in again.', isError: true);
      return;
    }

    if (_imagePath == null || _imagePath!.isEmpty) {
      _showSnack('Please pick an image before submitting.', isError: true);
      return;
    }

    final formDataMap = {
      'name': _nameController.text.trim(),
      'description': _descriptionController.text.trim(),
      'location': _locationController.text.trim(),
      'ticketPrice': double.tryParse(_priceController.text.trim()) ?? 0.0,
      'capacityPerSlot': int.tryParse(_capacityController.text.trim()) ?? 0,
      'timings': {
        'opening': _openingController.text.trim(),
        'closing': _closingController.text.trim(),
      },
      'isActive': _isActive,
    };

    final formData = FormData.fromMap(formDataMap);

    if (_imagePath != null && _imagePath!.isNotEmpty) {
      final file = File(_imagePath!);
      if (file.existsSync()) {
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              _imagePath!,
              filename: file.uri.pathSegments.last,
            ),
          ),
        );
      } else {
        _showSnack('Image file not found at path: $_imagePath', isError: true);
      }
    }

    setState(() => _isSubmitting = true);
    try {
      debugPrint('Create attraction payload: $formData');
      final response = await apiClient.post(
        '/api/attractions',
        formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      debugPrint('Create attraction response: $response');
      ref.invalidate(attractionsProvider);
      _showSnack('Attraction created');
      form.reset();
      _nameController.clear();
      _descriptionController.clear();
      _locationController.clear();
      _openingController.text = '09:00 AM';
      _closingController.text = '06:00 PM';
      _priceController.text = '25.50';
      _capacityController.text = '40';
      _imagePath = null;
      setState(() {
        _isActive = true;
      });
      if (!mounted) return;
      await _showCreateSuccessDialog();
    } on ApiException catch (error) {
      debugPrint('Create attraction API error: $error');
      _showSnack(
        _extractMessage(error) ?? 'Failed to create attraction.',
        isError: true,
      );
    } catch (_) {
      _showSnack('Failed to create attraction.', isError: true);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _showCreateSuccessDialog() async {
    final goHome = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Attraction created'),
          content: const Text(
            'Do you want to create another attraction or go home?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Create More'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Go Home'),
            ),
          ],
        );
      },
    );

    if (!mounted || goHome != true) return;

    ref.read(appTabIndexProvider.notifier).state = 0;
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.popUntil((route) => route.isFirst);
    } else {
      navigator.pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const AppShell()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create Attraction',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            vSpaceS,
            Text(
              'Add a new attraction with details and ticket price.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            vSpaceM,
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Enter a name' : null,
            ),
            vSpaceM,
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                alignLabelWithHint: true,
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Enter a description' : null,
            ),
            vSpaceM,
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Enter a location' : null,
            ),
            vSpaceM,
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _openingController.text,
                    items: _timeOptions
                        .map(
                          (time) => DropdownMenuItem<String>(
                            value: time,
                            child: Text(time),
                          ),
                        )
                        .toList(growable: false),
                    decoration: const InputDecoration(
                      labelText: 'Opening Time',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _openingController.text = value);
                      }
                    },
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                ),
                hSpaceM,
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _closingController.text,
                    items: _timeOptions
                        .map(
                          (time) => DropdownMenuItem<String>(
                            value: time,
                            child: Text(time),
                          ),
                        )
                        .toList(growable: false),
                    decoration: const InputDecoration(
                      labelText: 'Closing Time',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _closingController.text = value);
                      }
                    },
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                ),
              ],
            ),
            vSpaceM,
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Ticket Price',
                border: OutlineInputBorder(),
              ),
              validator: (v) => int.tryParse(v?.trim() ?? '') == null
                  ? 'Enter a number'
                  : null,
            ),
            vSpaceM,
            TextFormField(
              controller: _capacityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Capacity Per Slot',
                border: OutlineInputBorder(),
              ),
              validator: (v) => int.tryParse(v?.trim() ?? '') == null
                  ? 'Enter a capacity number'
                  : null,
            ),
            vSpaceM,
            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Image',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.insert_drive_file,
                    color: (_imagePath == null || _imagePath!.isEmpty)
                        ? AppColors.inkMuted
                        : AppColors.brand,
                  ),
                  hSpaceS,
                  Expanded(
                    child: Text(
                      _imagePath == null || _imagePath!.isEmpty
                          ? 'Choose an Image'
                          : 'File Uploaded',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ),
                  hSpaceS,
                  OutlineChipButton(label: 'Pick Image', onPressed: _pickImage),
                ],
              ),
            ),
            vSpaceM,
            Row(
              children: [
                Switch(
                  value: _isActive,
                  onChanged: (value) => setState(() => _isActive = value),
                  activeColor: AppColors.brand,
                ),
                const SizedBox(width: 8),
                const Text('Active'),
              ],
            ),

            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                label: _isSubmitting ? 'Creating...' : 'Create Attraction',
                onPressed: _isSubmitting ? null : _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
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
}

class _ScanCard extends StatefulWidget {
  final VoidCallback onActivate;

  const _ScanCard({required this.onActivate});

  @override
  State<_ScanCard> createState() => _ScanCardState();
}

class _ScanCardState extends State<_ScanCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scanPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _scanPosition = Tween<double>(
      begin: -0.35,
      end: 0.35,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: Column(
        children: [
          Container(
            height: 180,
            width: 180,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F6FB),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: AppColors.outline, width: 2),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.qr_code_2_rounded,
                  size: 90,
                  color: Color(0xFFB7C7D9),
                ),
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _scanPosition,
                    builder: (context, child) {
                      return Align(
                        alignment: Alignment(0, _scanPosition.value),
                        child: child,
                      );
                    },
                    child: Container(
                      height: 30,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(0, 255, 255, 255),
                            Color(0x552E7BB9),
                            Color(0xAA2E7BB9),
                            Color(0x552E7BB9),
                            Color.fromARGB(0, 252, 252, 253),
                          ],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x332E7BB9),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          vSpaceM,
          Text(
            'Align QR Code',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          vSpaceS,
          Text(
            "Position the visitor's ticket QR code within the frame to scan.",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          vSpaceM,
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: widget.onActivate,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF0B6FA5),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              child: const Text('Scan Now'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ValidationMessage extends StatelessWidget {
  final String message;
  final bool isSuccess;

  const _ValidationMessage({required this.message, required this.isSuccess});

  @override
  Widget build(BuildContext context) {
    final color = isSuccess ? const Color(0xFF1E8E3E) : const Color(0xFFB3261E);
    final background = isSuccess
        ? const Color(0xFFE8F5E9)
        : const Color(0xFFFDE7E9);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(isSuccess ? Icons.verified : Icons.error_outline, color: color),
          hSpaceS,
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
