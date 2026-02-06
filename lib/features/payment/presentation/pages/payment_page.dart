import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:park_ticket/core/theme/app_colors.dart';
import 'package:park_ticket/core/utils/formatters.dart';
import 'package:park_ticket/core/utils/spacing.dart';
import 'package:park_ticket/core/widgets/outline_chip_button.dart';
import 'package:park_ticket/core/widgets/primary_button.dart';
import 'package:park_ticket/features/attraction/domain/entities/attraction.dart';
import 'package:park_ticket/features/booking/domain/entities/booking.dart';
import 'package:park_ticket/features/payment/presentation/providers/payment_flow_provider.dart';
import 'package:park_ticket/features/ticket/presentation/pages/ticket_confirmation_page.dart';

class PaymentPage extends ConsumerWidget {
  final Attraction attraction;
  final Booking booking;

  const PaymentPage({
    super.key,
    required this.attraction,
    required this.booking,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flowState = ref.watch(paymentFlowControllerProvider);
    final flowController = ref.read(paymentFlowControllerProvider.notifier);

    Future<void> confirmPayment() async {
      final ticket = await flowController.confirm(booking);
      if (ticket == null) return;
      if (!context.mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => const TicketConfirmationPage(),
        ),
      );
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
                                'Payment',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: AppColors.inkMuted,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Text(
                                'Payment Simulation',
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
                      _PaymentCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE7F3FB),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.verified_user_outlined,
                                    color: Color(0xFF0B6FA5),
                                  ),
                                ),
                                hSpaceS,
                                Text(
                                  'This is a simulated payment.',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            vSpaceM,
                            _SummaryPanel(
                              attractionName: attraction.name,
                              dateLabel: booking.visitDate
                                  .toIso8601String()
                                  .split('T')
                                  .first,
                              timeLabel: booking.timeSlot,
                              tickets: booking.quantity,
                              totalLabel: formatPrice(booking.totalCents),
                            ),
                          ],
                        ),
                      ),
                      vSpaceM,
                      SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                          label: flowState.isProcessing
                              ? 'Confirming...'
                              : 'Confirm Payment',
                          trailingIcon: Icons.arrow_forward,
                          onPressed: flowState.isProcessing
                              ? null
                              : confirmPayment,
                        ),
                      ),
                      if (flowState.errorMessage != null) ...[
                        vSpaceS,
                        Text(
                          flowState.errorMessage!,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: const Color(0xFFB3261E)),
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

class _PaymentCard extends StatelessWidget {
  final Widget child;

  const _PaymentCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.outline),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 24,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SummaryPanel extends StatelessWidget {
  final String attractionName;
  final String dateLabel;
  final String timeLabel;
  final int tickets;
  final String totalLabel;

  const _SummaryPanel({
    required this.attractionName,
    required this.dateLabel,
    required this.timeLabel,
    required this.tickets,
    required this.totalLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            attractionName,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          vSpaceM,
          _SummaryRow(label: 'Date', value: dateLabel),
          vSpaceS,
          _SummaryRow(label: 'Time', value: timeLabel),
          vSpaceS,
          _SummaryRow(label: 'Tickets', value: '$tickets'),
          vSpaceM,
          const Divider(height: 20, color: AppColors.outline),
          _SummaryRow(label: 'Total', value: totalLabel, highlight: true),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final valueStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
      color: highlight ? const Color(0xFF0B6FA5) : AppColors.ink,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(value, style: valueStyle),
      ],
    );
  }
}
