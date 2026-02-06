import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:park_ticket/core/theme/app_colors.dart';
import 'package:park_ticket/core/utils/spacing.dart';
import 'package:park_ticket/core/widgets/outline_chip_button.dart';
import 'package:park_ticket/core/widgets/primary_button.dart';
import 'package:park_ticket/features/admin/presentation/providers/gate_validation_provider.dart';

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

    Future<void> validateTicket() async {
      await notifier.validate(controller.text);
    }

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
                                'Gate Validation',
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
                      _ModeToggle(
                        mode: mode,
                        onChanged: (nextMode) {
                          ref.read(gateValidationModeProvider.notifier).state =
                              nextMode;
                          notifier.clearMessages();
                        },
                      ),
                      vSpaceM,
                      if (mode == GateValidationMode.manual)
                        _ManualEntryCard(
                          controller: controller,
                          isLoading: state.isLoading,
                          onSubmit: validateTicket,
                          onScanTap: openScanner,
                          onClearMessages: () {
                            if (state.errorMessage != null ||
                                state.result != null) {
                              notifier.clearMessages();
                            }
                          },
                        ),
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
              label: 'Manual Entry',
              selected: mode == GateValidationMode.manual,
              onTap: () => onChanged(GateValidationMode.manual),
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

class _ManualEntryCard extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSubmit;
  final VoidCallback onScanTap;
  final VoidCallback onClearMessages;

  const _ManualEntryCard({
    required this.controller,
    required this.isLoading,
    required this.onSubmit,
    required this.onScanTap,
    required this.onClearMessages,
  });

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Enter ID', style: Theme.of(context).textTheme.headlineMedium),
          vSpaceS,
          Text(
            'Type the booking number from the ticket.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          vSpaceM,
          TextField(
            controller: controller,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => onSubmit(),
            onChanged: (_) => onClearMessages(),
            decoration: InputDecoration(
              hintText: 'e.g., DF-AB12-CD34',
              prefixIcon: const Icon(Icons.text_fields),
              suffixIcon: IconButton(
                icon: const Icon(Icons.qr_code_scanner),
                onPressed: onScanTap,
              ),
            ),
          ),
          vSpaceM,
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              label: isLoading ? 'Checking...' : 'Check Ticket',
              trailingIcon: Icons.arrow_forward,
              onPressed: isLoading ? null : onSubmit,
            ),
          ),
        ],
      ),
    );
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
        border: Border.all(color: color.withOpacity(0.3)),
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
