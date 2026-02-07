import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:park_ticket/features/booking/domain/entities/booking.dart';
import 'package:park_ticket/features/ticket/domain/entities/ticket.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:park_ticket/core/theme/app_colors.dart';
import 'package:park_ticket/core/utils/formatters.dart';
import 'package:park_ticket/core/utils/spacing.dart';
import 'package:park_ticket/core/widgets/outline_chip_button.dart';
import 'package:park_ticket/core/widgets/primary_button.dart';
import 'package:park_ticket/features/ticket/presentation/providers/ticket_session_provider.dart';

class TicketConfirmationPage extends ConsumerWidget {
  const TicketConfirmationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(lastTicketSnapshotProvider);
    if (snapshot != null) {
      return _TicketConfirmationBody(
        booking: snapshot.booking,
        ticket: snapshot.ticket,
      );
    }
    return _TicketStateScaffold(
      title: 'No ticket selected',
      message: 'Pick a ticket from your history to view its details.',
      actionLabel: 'Back to Tickets',
      onAction: () => Navigator.of(context).pop(),
      secondaryLabel: 'Back to Home',
      onSecondary: () =>
          Navigator.of(context).popUntil((route) => route.isFirst),
    );
  }
}

class _TicketConfirmationBody extends StatelessWidget {
  final Booking booking;
  final Ticket ticket;

  const _TicketConfirmationBody({required this.booking, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final visitDate = booking.visitDate.toIso8601String().split('T').first;
    final attractionName = booking.attractionName?.trim() ?? '';
    final paymentReference = booking.paymentReference?.trim() ?? '';
    final hasQrImage = (booking.qrCodeImage ?? '').trim().isNotEmpty;

    final details = <_DetailRow>[
      _DetailRow(label: 'Booking ID', value: formatBookingId(booking.id)),
      if (attractionName.isNotEmpty)
        _DetailRow(label: 'Attraction', value: attractionName),
      _DetailRow(label: 'Visit date', value: visitDate),
      _DetailRow(label: 'Time', value: booking.timeSlot),
      _DetailRow(label: 'Tickets', value: '${booking.quantity}'),
      if (paymentReference.isNotEmpty)
        _DetailRow(label: 'Payment Ref', value: paymentReference),
      _DetailRow(label: 'Status', value: booking.status),
      if ((booking.totalAmount ?? 0) > 0)
        _DetailRow(
          label: 'Subtotal',
          value: formatPrice(booking.totalAmount ?? 0),
        ),
      if ((booking.taxAmount ?? 0) > 0)
        _DetailRow(label: 'Tax', value: formatPrice(booking.taxAmount ?? 0)),
      if ((booking.finalAmount ?? 0) > 0)
        _DetailRow(
          label: 'Total',
          value: formatPrice(booking.finalAmount ?? 0),
        ),
    ];

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
                                'Ticket',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: AppColors.inkMuted,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Text(
                                'Ticket Confirmation',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineMedium,
                              ),
                              if (attractionName.isNotEmpty) ...[
                                vSpaceS,
                                Text(
                                  attractionName,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(color: AppColors.inkMuted),
                                ),
                              ],
                            ],
                          ),
                          OutlineChipButton(
                            label: 'Home',
                            onPressed: () => Navigator.of(
                              context,
                            ).popUntil((route) => route.isFirst),
                          ),
                        ],
                      ),
                      vSpaceM,
                      _TicketCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 44,
                                  width: 44,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE7F3FB),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.check_circle_outline,
                                    color: Color(0xFF0B6FA5),
                                  ),
                                ),
                                hSpaceS,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Booking Confirmed',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge,
                                    ),
                                    vSpaceS,
                                    Text(
                                      'Save a screenshot for quick entry.',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            vSpaceM,
                            _DetailsCard(rows: details),
                            vSpaceM,
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFD),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: AppColors.outline),
                                ),
                                child: hasQrImage
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          booking.qrCodeImage!,
                                          height: 220,
                                          width: 220,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return QrImageView(
                                                  data: ticket.qrToken,
                                                  size: 220,
                                                  backgroundColor: Colors.white,
                                                );
                                              },
                                        ),
                                      )
                                    : QrImageView(
                                        data: ticket.qrToken,
                                        size: 220,
                                        backgroundColor: Colors.white,
                                      ),
                              ),
                            ),
                            vSpaceM,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.qr_code_scanner,
                                  color: AppColors.inkMuted,
                                ),
                                hSpaceS,
                                Flexible(
                                  child: Text(
                                    'Show this QR code at the entrance gate',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            vSpaceM,

                            // SizedBox(
                            //   width: double.infinity,
                            //   child: OutlinedButton.icon(
                            //     onPressed: () {},
                            //     icon: const Icon(Icons.download),
                            //     label: const Text('Save Screenshot (Tip)'),
                            //     style: OutlinedButton.styleFrom(
                            //       foregroundColor: AppColors.ink,
                            //       backgroundColor: const Color(0xFFF0F3F8),
                            //       side: const BorderSide(
                            //         color: AppColors.outline,
                            //       ),
                            //       padding: const EdgeInsets.symmetric(
                            //         vertical: 14,
                            //       ),
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(26),
                            //       ),
                            //       textStyle: const TextStyle(
                            //         fontWeight: FontWeight.w600,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      vSpaceM,
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

class _TicketStateScaffold extends StatelessWidget {
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  const _TicketStateScaffold({
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    this.secondaryLabel,
    this.onSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                vSpaceS,
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                vSpaceM,
                PrimaryButton(label: actionLabel, onPressed: onAction),
                if (secondaryLabel != null && onSecondary != null) ...[
                  vSpaceS,
                  OutlineChipButton(
                    label: secondaryLabel!,
                    onPressed: onSecondary,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  final Widget child;

  const _TicketCard({required this.child});

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

class _DetailsCard extends StatelessWidget {
  final List<_DetailRow> rows;

  const _DetailsCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            rows[i],
            if (i != rows.length - 1) vSpaceS,
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
