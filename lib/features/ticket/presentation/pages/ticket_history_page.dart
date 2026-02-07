import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:park_ticket/core/theme/app_colors.dart';
import 'package:park_ticket/core/utils/formatters.dart';
import 'package:park_ticket/core/utils/spacing.dart';
import 'package:park_ticket/core/widgets/outline_chip_button.dart';
import 'package:park_ticket/core/widgets/primary_button.dart';
import 'package:park_ticket/features/ticket/presentation/pages/ticket_confirmation_page.dart';
import 'package:park_ticket/features/ticket/presentation/providers/ticket_provider.dart';
import 'package:park_ticket/features/ticket/presentation/providers/ticket_session_provider.dart';

class TicketHistoryPage extends ConsumerWidget {
  const TicketHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(ticketHistoryRemoteProvider);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth < 500 ? 16.0 : 28.0;
            final contentWidth =
                constraints.maxWidth > 720 ? 720.0 : constraints.maxWidth;

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
                      Text(
                        'Tickets',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.inkMuted,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        'Purchased Tickets',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      vSpaceM,
                      historyAsync.when(
                        data: (records) {
                          debugPrint(
                            'Ticket history loaded: ${records.length} records',
                          );
                          if (records.isEmpty) {
                            return _EmptyTicketHistory(
                              onExplore: () => Navigator.of(context)
                                  .popUntil((route) => route.isFirst),
                            );
                          }
                          return ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: records.length,
                            separatorBuilder: (_, __) => vSpaceS,
                            itemBuilder: (context, index) {
                              final record = records[index];
                              final snapshot = TicketSnapshot(
                                booking: record.booking,
                                ticket: record.ticket,
                              );
                              return _TicketHistoryCard(
                                bookingId: record.booking.id,
                                visitDate: record.booking.visitDate
                                    .toIso8601String()
                                    .split('T')
                                    .first,
                                timeSlot: record.booking.timeSlot,
                                quantity: record.booking.quantity,
                                status: record.booking.status,
                                onView: () {
                                  ref
                                      .read(
                                        lastTicketBookingIdProvider.notifier,
                                      )
                                      .state = record.booking.id;
                                  ref
                                      .read(
                                        lastTicketSnapshotProvider.notifier,
                                      )
                                      .state = snapshot;
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) =>
                                          const TicketConfirmationPage(),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                        loading: () => const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 80),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        error: (error, stackTrace) {
                          debugPrint('Ticket history error: $error');
                          return _TicketHistoryError(
                            message:
                                'Unable to load your tickets right now. Please try again.',
                            onRetry: () =>
                                ref.refresh(ticketHistoryRemoteProvider),
                          );
                        },
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

class _EmptyTicketHistory extends StatelessWidget {
  final VoidCallback onExplore;

  const _EmptyTicketHistory({required this.onExplore});

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
            blurRadius: 24,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No tickets yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          vSpaceS,
          Text(
            'Book a visit and your ticket history will appear here.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          vSpaceM,
          PrimaryButton(label: 'Explore Attractions', onPressed: onExplore),
        ],
      ),
    );
  }
}

class _TicketHistoryError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _TicketHistoryError({
    required this.message,
    required this.onRetry,
  });

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
            blurRadius: 24,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'We hit a snag',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          vSpaceS,
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          vSpaceM,
          PrimaryButton(label: 'Try Again', onPressed: onRetry),
        ],
      ),
    );
  }
}

class _TicketHistoryCard extends StatelessWidget {
  final String bookingId;
  final String visitDate;
  final String timeSlot;
  final int quantity;
  final String status;
  final VoidCallback onView;

  const _TicketHistoryCard({
    required this.bookingId,
    required this.visitDate,
    required this.timeSlot,
    required this.quantity,
    required this.status,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Booking ${formatBookingId(bookingId)}',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              _StatusChip(status: status),
            ],
          ),
          vSpaceS,
          _InfoRow(label: 'Visit date', value: visitDate),
          vSpaceS,
          _InfoRow(label: 'Time', value: timeSlot),
          vSpaceS,
          _InfoRow(label: 'Tickets', value: quantity.toString()),
          vSpaceM,
          Align(
            alignment: Alignment.centerRight,
            child: OutlineChipButton(label: 'View Ticket', onPressed: onView),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  Color get _color {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFF0B6FA5);
      case 'pending':
        return const Color(0xFFF5A524);
      case 'cancelled':
        return const Color(0xFFB3261E);
      default:
        return AppColors.inkMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.isEmpty ? 'Unknown' : status,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
