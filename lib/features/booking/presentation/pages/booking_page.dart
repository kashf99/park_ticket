import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:park_ticket/core/theme/app_colors.dart';
import 'package:park_ticket/core/utils/formatters.dart';
import 'package:park_ticket/core/utils/spacing.dart';
import 'package:park_ticket/core/widgets/outline_chip_button.dart';
import 'package:park_ticket/core/widgets/primary_button.dart';
import 'package:park_ticket/features/attraction/domain/entities/attraction.dart';
import 'package:park_ticket/features/booking/domain/entities/booking.dart';
import 'package:park_ticket/features/booking/presentation/providers/booking_form_provider.dart';
import 'package:park_ticket/features/payment/presentation/pages/payment_page.dart';

class BookingPage extends ConsumerWidget {
  final Attraction attraction;

  const BookingPage({super.key, required this.attraction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookingFormControllerProvider);
    final notifier = ref.read(bookingFormControllerProvider.notifier);
    final canProceed = ref.watch(bookingCanProceedProvider);
    final timeSlots = ref.watch(bookingTimeSlotsProvider(attraction));

    if (timeSlots.isNotEmpty && !timeSlots.contains(state.timeSlot)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!timeSlots.contains(state.timeSlot)) {
          notifier.setTimeSlot(timeSlots.first);
        }
      });
    }

    Future<void> pickDate() async {
      final selected = await showDatePicker(
        context: context,
        initialDate: state.visitDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );
      if (selected != null) {
        notifier.setVisitDate(selected);
      }
    }

    final totalCents = attraction.price * state.quantity;

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
                                attraction.name,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: AppColors.inkMuted,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Text(
                                'Book Your Visit',
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
                      _BookingCard(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Visit date',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                vSpaceS,
                                Text(
                                  'Pick a date from the calendar.',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            _DatePill(
                              label: formatShortDate(state.visitDate),
                              onTap: pickDate,
                            ),
                          ],
                        ),
                      ),
                      vSpaceM,
                      _BookingCard(
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
                                      'Time slot',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge,
                                    ),
                                    vSpaceS,
                                    Text(
                                      'Choose an available entry time.',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                                Text(
                                  state.timeSlot,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(color: AppColors.inkMuted),
                                ),
                              ],
                            ),
                            vSpaceM,
                            _TimeSlotGrid(
                              slots: timeSlots,
                              selected: state.timeSlot,
                              onSelected: notifier.setTimeSlot,
                            ),
                          ],
                        ),
                      ),
                      vSpaceM,
                      _BookingCard(
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
                                      'Tickets',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge,
                                    ),
                                    vSpaceS,
                                    Text(
                                      'Select quantity.',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                                _QuantityStepper(
                                  value: state.quantity,
                                  onDecrement: notifier.decrementQuantity,
                                  onIncrement: notifier.incrementQuantity,
                                ),
                              ],
                            ),
                            vSpaceM,
                            _SummaryCard(
                              priceLabel: formatPrice(attraction.price),
                              quantity: state.quantity,
                              totalLabel: formatPrice(totalCents),
                            ),
                          ],
                        ),
                      ),
                      vSpaceM,
                      _BookingCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your details',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            vSpaceM,
                            Text(
                              'Full name',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            vSpaceS,
                            TextField(
                              onChanged: notifier.setName,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                hintText: 'e.g., Aisha Khan',
                              ),
                            ),
                            vSpaceM,
                            Text(
                              'Email address',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            vSpaceS,
                            TextField(
                              onChanged: notifier.setEmail,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                hintText: 'you@example.com',
                              ),
                            ),
                          ],
                        ),
                      ),
                      vSpaceM,
                      SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                          label: 'Proceed to Payment',
                          trailingIcon: Icons.arrow_forward,
                          onPressed: !canProceed
                              ? null
                              : () {
                                  final booking = Booking(
                                    id: '',
                                    attractionId: attraction.id,
                                    visitDate: state.visitDate,
                                    timeSlot: state.timeSlot,
                                    quantity: state.quantity,
                                    name: state.name,
                                    email: state.email,
                                    totalCents: totalCents,
                                    status: 'pending',
                                    qrToken: null,
                                  );
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => PaymentPage(
                                        attraction: attraction,
                                        booking: booking,
                                      ),
                                    ),
                                  );
                                },
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

class _BookingCard extends StatelessWidget {
  final Widget child;

  const _BookingCard({required this.child});

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

class _DatePill extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DatePill({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F3F8),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.outline),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_month, color: AppColors.ink),
            hSpaceS,
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeSlotChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TimeSlotChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF0B6FA5) : Colors.white;
    final textColor = selected ? Colors.white : AppColors.ink;
    return InkWell(
      borderRadius: BorderRadius.circular(26),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: selected ? color : AppColors.outline),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: textColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _TimeSlotGrid extends StatelessWidget {
  final List<String> slots;
  final String selected;
  final ValueChanged<String> onSelected;

  const _TimeSlotGrid({
    required this.slots,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    const columns = 3;
    const rowHeight = 46.0;
    const spacing = 10.0;
    final rows = (slots.length / columns).ceil();
    final visibleRows = rows > 3 ? 3 : rows;
    final double height = visibleRows == 0
        ? 0
        : (rowHeight * visibleRows) + (spacing * (visibleRows - 1));

    return SizedBox(
      height: height,
      child: Stack(
        children: [
          ListView.builder(
            padding: EdgeInsets.zero,
            primary: false,
            physics: const ClampingScrollPhysics(),
            itemCount: rows,
            itemBuilder: (context, rowIndex) {
              final start = rowIndex * columns;
              final end = (start + columns).clamp(0, slots.length);
              final rowSlots = slots.sublist(start, end);

              return Padding(
                padding: EdgeInsets.only(
                  bottom: rowIndex == rows - 1 ? 0 : spacing,
                ),
                child: SizedBox(
                  height: rowHeight,
                  child: Row(
                    children: [
                      for (final slot in rowSlots)
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: slot == rowSlots.last ? 0 : spacing,
                            ),
                            child: _TimeSlotChip(
                              label: slot,
                              selected: slot == selected,
                              onTap: () => onSelected(slot),
                            ),
                          ),
                        ),
                      for (var i = rowSlots.length; i < columns; i++)
                        const Expanded(child: SizedBox()),
                    ],
                  ),
                ),
              );
            },
          ),
          if (rows > 3)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 28,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0),
                        Colors.white.withValues(alpha: 0.9),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _QuantityStepper({
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _QuantityButton(icon: Icons.remove, onTap: onDecrement),
        SizedBox(
          width: 36,
          child: Text(
            '$value',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        _QuantityButton(icon: Icons.add, onTap: onIncrement),
      ],
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        height: 36,
        width: 36,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F3F8),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.outline),
        ),
        child: Icon(icon, size: 20, color: AppColors.ink),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String priceLabel;
  final int quantity;
  final String totalLabel;

  const _SummaryCard({
    required this.priceLabel,
    required this.quantity,
    required this.totalLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        children: [
          _SummaryRow(label: 'Ticket price', value: priceLabel),
          vSpaceS,
          _SummaryRow(label: 'Quantity', value: '$quantity'),
          vSpaceS,
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
